import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:talkitup/Models/Enums/join_request_status.dart';
import 'package:talkitup/Models/Enums/room_status.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/room.dart';
import 'package:talkitup/Providers/user_provider.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:talkitup/UI/ProfileShortView.dart';
import 'package:talkitup/UI/bg_gradient.dart';
import 'package:talkitup/UI/create_room_widget.dart';
import 'package:talkitup/UI/room_page.dart';

import 'Models/room_details.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFetching = true;
  List<RoomDetails> rooms = [];
  void _fetch() {
    FirestoreServices.roomStream.listen((snapshots) {
      List<RoomDetails> newRooms = [];
      snapshots.docs.map((doc) => doc.data()).forEach(
        (data) {
          if (data != null) {
            final obj = RoomDetails(Room.fromJson(jsonEncode(data))!);
            newRooms.add(obj);
            FirestoreServices.fetchAttendee(obj.id).then((attendees) {
              attendees.sort((first, second) => first.isSpeaker ? 1 : -1);
              obj.attendees = attendees;
              setState(() {});
            });
          }
        },
      );
      rooms = newRooms;
      setState(() {
        _isFetching = false;
      });
    });
  }

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  void createRoom(String title, MemoryImage? image) async {
    final userDetails =
        Provider.of<UserProvider>(context, listen: false).userDetails!;

    final hostAsAttendee = Attendee(
      (b) => b
        ..userId = userDetails.id
        ..username = userDetails.username
        ..name = userDetails.name
        ..image = userDetails.image
        ..isSpeaker = true
        ..isMuted = true
        ..timestamp = Timestamp.now().millisecondsSinceEpoch
        ..requestStatus = JoinRequestStatus.accepted,
    );

    final room = Room((b) => b
      ..id = nanoid()
      ..creator = hostAsAttendee.toBuilder()
      ..title = title
      ..status = RoomStatus.live
      ..description = '');
    final res = await FirestoreServices.saveRoom(room, image);
    if (res) Navigator.of(context).pop();
  }

  void _showCreateRoomDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => SimpleDialog(
        backgroundColor: Colors.transparent,
        children: [
          SizedBox(
            width: MediaQuery.of(ctx).size.width * 0.75,
            child: CreateRoomWidget(createRoom),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: rooms.isEmpty ? null : _createCardButton,
        body: BgGradient(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(),
                    Text(
                      'Talk It Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final _currentUser =
                            Provider.of<UserProvider>(context, listen: false)
                                .userDetails!;
                        ProfileShortView.display(
                            context,
                            Attendee((b) => b
                              ..userId = _currentUser.id
                              ..username = _currentUser.username
                              ..name = _currentUser.name
                              ..image = _currentUser.image
                              ..isSpeaker = false
                              ..timestamp =
                                  Timestamp.now().millisecondsSinceEpoch
                              ..requestStatus = JoinRequestStatus.none));
                      },
                      icon: Icon(
                        Icons.person_pin,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: rooms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "No Rooms to show.\nLet's create one ❤️",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            _createCardButton,
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: rooms.length + 1,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          if (index == rooms.length) {
                            return const SizedBox(height: 100);
                          }
                          final room = rooms[index].room;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 8),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: MediaQuery.of(context).size.width *
                                    0.85 *
                                    9 /
                                    16,
                                child: InkWell(
                                  onTap: () {
                                    // TODO: navigate to club detail page
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RoomPage(rooms[index]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    shadowColor: Colors.pinkAccent,
                                    elevation: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: room.image == null
                                            ? null
                                            : DecorationImage(
                                                image:
                                                    NetworkImage(room.image!),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12,
                                              Colors.black26,
                                              Colors.black54,
                                              Colors.black.withOpacity(0.7),
                                              Colors.black.withOpacity(0.7),
                                            ],
                                            stops: [0.4, 0.6, 0.7, 0.8, 0.9],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: roomStatusWidget(room),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    room.title,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    room.creator.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  SizedBox(
                                                    height: 32,
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: 36 * 4.0,
                                                          child:
                                                              _paticipantListBuilder(
                                                            rooms[index]
                                                                .attendees,
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .headset_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              '${rooms[index].attendees.length}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _createCardButton => InkWell(
        onTap: _showCreateRoomDialog,
        child: Card(
          color: Colors.redAccent,
          shadowColor: Colors.yellow,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  size: 24,
                  color: Colors.greenAccent,
                ),
                SizedBox(width: 12),
                Text(
                  "Create",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget roomStatusWidget(Room room) {
    final color = room.status == RoomStatus.future ? Colors.green : Colors.red;
    final text = room.status == RoomStatus.future ? 'Waiting' : 'Live';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      color: color,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _paticipantListBuilder(List<Attendee> attendees) {
    final totalParticipants = attendees.length;

    // we are showing at max 3 participants

    int invisibleParticipantCount = 0;
    if (totalParticipants >= 4) {
      invisibleParticipantCount = totalParticipants - 3;
    }

    return ListView.builder(
      itemCount: totalParticipants >= 4 ? 4 : totalParticipants,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        final speaker = attendees[index];

        Widget avatarCard(child) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: SizedBox(
                height: 32,
                width: 32,
                child: child,
              ),
            );
        if (index == 3) {
          return avatarCard(Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '+${invisibleParticipantCount.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ));
        }
        // final imageUrl = club.participants.toList()[index];
        return avatarCard(CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: speaker.image == null
              ? const Icon(
                  Icons.emoji_emotions,
                  color: Colors.yellow,
                  size: 20,
                )
              : CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(speaker.image!),
                ),
        ));
      },
    );
  }
}
