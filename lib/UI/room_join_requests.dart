import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:talkitup/Models/Enums/join_request_status.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:talkitup/UI/loading_widget.dart';

import 'ProfileShortView.dart';

class RoomJoinRequests extends StatefulWidget {
  final List<Attendee> requesters;
  final String roomId;
  const RoomJoinRequests(this.requesters, this.roomId);
  @override
  _RoomJoinRequestsState createState() => _RoomJoinRequestsState();
}

class _RoomJoinRequestsState extends State<RoomJoinRequests> {
  bool isLoading = false;

  Future<void> loadingCycle(Function function) async {
    setState(() {
      isLoading = true;
    });

    if (function != null) await function();

    setState(() {
      isLoading = false;
    });
  }

  acceptJoinRequest(Attendee requester) async {
    requester = requester.rebuild(
      (b) => b
        ..requestStatus = JoinRequestStatus.accepted
        ..isSpeaker = true
        ..isMuted = true,
    );
    final res = await FirestoreServices.saveAttendee(requester, widget.roomId,
        update: true);
    if (res) {
      Fluttertoast.showToast(msg: "Join Request Accepted");
    }
    widget.requesters
        .removeWhere((element) => element.userId == requester.userId);

    setState(() {});
  }

  Card get acceptCard => Card(
        color: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Accept',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  Widget requesterList() {
    final listLength = widget.requesters.length;
    if (listLength == 0) {
      return const Center(
        child: Text(
          'No Requests...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listLength,
      itemBuilder: (context, index) {
        final requester = widget.requesters[index];
        return Container(
          key: ValueKey(requester.userId + ' $index'),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => ProfileShortView.display(context, requester),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      image: requester.image == null
                          ? null
                          : DecorationImage(
                              image: NetworkImage(requester.image!),
                              fit: BoxFit.fill)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    requester.username,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await acceptJoinRequest(requester);
                },
                child: acceptCard,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
        child: Column(
          children: [
            const Text(
              'Join Requests',
              style: const TextStyle(color: Colors.redAccent, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? Center(
                      child: LoadingWidget(),
                    )
                  : requesterList(),
            ),
          ],
        ),
      ),
    );
  }
}
