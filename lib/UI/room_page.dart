import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart' as RTC;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:talkitup/Models/Enums/join_request_status.dart';
import 'package:talkitup/Models/Enums/room_status.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/comment.dart';
import 'package:talkitup/Models/room.dart';
import 'package:talkitup/Models/user_details.dart';
import 'package:talkitup/Providers/agora_controller.dart';
import 'package:talkitup/Providers/user_provider.dart';
import 'package:talkitup/Services/firestore_services.dart';
import 'package:talkitup/UI/Models/room_details.dart';
import 'package:talkitup/UI/bg_gradient.dart';
import 'package:talkitup/UI/loading_widget.dart';
import 'package:talkitup/UI/participant_action_dialog.dart';
import 'package:talkitup/UI/participant_card.dart';
import 'package:talkitup/UI/rightSideSheet.dart';
import 'package:talkitup/UI/room_join_requests.dart';
import 'package:talkitup/UI/utils.dart';
import 'package:http/http.dart' as http;

import 'ClubFulllDataSheet.dart';
import 'ProfileShortView.dart';
import 'commentBox.dart';

class RoomPage extends StatefulWidget {
  final RoomDetails roomDetails;

  const RoomPage(this.roomDetails, {Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  late UserDetails _currentUser;
  late Attendee _hostUser;
  late bool _isOwner;
  late Room _room;
  late List<Attendee> _attendees;
  late List<Attendee> _requesters;
  late bool _hasActiveJRs;

  late bool _convertedToSpeaker;
  late bool _joinedOnce;

  late Attendee _currentAttendee;

  String? _agoraToken;

  List<Comment> _comments = [];

  ValueNotifier<Map<String, int>> currentlySpeakingUsers = ValueNotifier({});
  final ScrollController _listController = ScrollController();
  final TextEditingController _newCommentController = TextEditingController();

  _refreshScreen() {
    if (mounted) setState(() {});
  }

  void _scountAttendees() {
    _requesters = _attendees
        .where((element) => element.requestStatus == JoinRequestStatus.pending)
        .toList();
    _hasActiveJRs = _requesters.isNotEmpty;
    for (var att in _attendees) {
      if (att.userId == _currentUser.id) {
        _currentAttendee = att;
        if (_currentAttendee.isSpeaker) {
          if (_convertedToSpeaker == false) {
            _convertedToSpeaker = true;
            Provider.of<AgoraController>(context, listen: false)
                .joinAsParticipant(
              roomId: _room.id,
              token: _agoraToken!,
              username: _currentAttendee.username,
            );
          }
        } else if (_joinedOnce == false) {
          Provider.of<AgoraController>(context, listen: false).joinAsAudience(
            roomId: _room.id,
            token: _agoraToken!,
            username: _currentAttendee.username,
          );
        }
        _joinedOnce = true;
        break;
      }
    }

    // putting usernames into integer username map for agora
    for (var attd in _attendees) {
      final integerUsername =
          Provider.of<AgoraController>(context, listen: false)
              .convertToInt(attd.username);
      Provider.of<AgoraController>(context, listen: false)
          .integerUsernames
          .putIfAbsent(integerUsername, () => attd.username);
    }

    _refreshScreen();
  }

  Future<void> _registerAttendee() async {
    _isLoading = true;

    if (_currentUser.id == _hostUser.userId) {
      _currentAttendee = _hostUser.rebuild(
        (b) => b
          ..name = _currentUser.name
          ..image = _currentUser.image
          ..timestamp = Timestamp.now().millisecondsSinceEpoch,
      );
    } else {
      _currentAttendee = Attendee(
        (b) => b
          ..userId = _currentUser.id
          ..username = _currentUser.username
          ..name = _currentUser.name
          ..image = _currentUser.image
          ..isSpeaker = false
          ..isMuted = true
          ..timestamp = Timestamp.now().millisecondsSinceEpoch
          ..requestStatus = JoinRequestStatus.none,
      );
    }

    final res =
        await FirestoreServices.saveAttendee(_currentAttendee, _room.id);
    _agoraToken = await _fetchAgoraToken();

    if (!res || _agoraToken == null) {
      Fluttertoast.showToast(msg: 'Something went wrong...');
      Navigator.of(context).pop();
      return;
    }

    _isLoading = false;

    _refreshScreen();
  }

  void _deRegisterAttendee() async {
    await FirestoreServices.deleteAttendee(_currentUser.id, _room.id);
  }

  bool emptySpeakerList = false;

  void _getActiveSpeakers(List<RTC.AudioVolumeInfo> speakers, _) {
    if (speakers.isEmpty && emptySpeakerList == false) {
      emptySpeakerList = true;
      return;
    } else {
      emptySpeakerList = false;
    }

    print("speakers.length ${speakers.length}");

    final integerUsernames =
        Provider.of<AgoraController>(context, listen: false).integerUsernames;

    var speakingUsers = Map<String, int>();
    for (var e in speakers) {
      if (e.uid == 0) {
        speakingUsers[_currentAttendee.username] = e.volume;
      } else {
        final username = integerUsernames[e.uid];
        if (username != null) speakingUsers[username] = e.volume;
      }
    }

// sorted in ascending order of volume
// when iterating over this list from beginning, participantList is sorted every time with participant with greater volume at first position.
    speakingUsers.entries.toList()
      ..sort((a, b) => a.value - b.value)
      ..forEach((element) {
        if (element.value < 50) return;
        _attendees.sort((a, b) {
          if (b.username == element.key) {
            return 1;
          } else {
            return 0;
          }
        });
      });

    // print(speakingUsers);

    currentlySpeakingUsers.value = speakingUsers;
  }

  void _onRemoteAudioStateChanged(
      int uid, _, RTC.AudioRemoteStateReason reason, __) {
    // for remote user: 5 when muted and 6 when unmuted
    if (reason.index != 5 && reason.index != 6) return;

    print('audio state change uid : $uid');

    bool isMuted = true;
    if (reason.index == 5) {
      isMuted = true;
    } else if (reason.index == 6) {
      isMuted = false;
    }

    final remoteAudioMuteStatesWithUid =
        Provider.of<AgoraController>(context, listen: false)
            .remoteAudioMuteStatesWithUid;
    final integerUsernames =
        Provider.of<AgoraController>(context, listen: false).integerUsernames;

    remoteAudioMuteStatesWithUid[uid] = isMuted;

    if (integerUsernames[uid] != null) {
      for (int i = 0; i < _attendees.length; i++) {
        var participant = _attendees[i];
        if (participant.username == integerUsernames[uid]) {
          _attendees[i] = _attendees[i].rebuild((b) => b..isMuted = isMuted);
          _refreshScreen();

          break;
        }
      }
    }
  }

  void _initAgoraCallbacks() {
    final _agoraEventHandler =
        Provider.of<AgoraController>(context, listen: false).agoraEventHandler;

    _agoraEventHandler?.audioVolumeIndication = _getActiveSpeakers;

    _agoraEventHandler?.remoteAudioStateChanged = _onRemoteAudioStateChanged;
  }

  Future<void> _disposeAgora() async {
    final _agoraEventHandler =
        Provider.of<AgoraController>(context, listen: false).agoraEventHandler;

    _agoraEventHandler?.audioVolumeIndication = null;
    _agoraEventHandler?.remoteAudioStateChanged = null;

    // stopping from agora
    await Provider.of<AgoraController>(context, listen: false).stop();
  }

  void _initiate() async {
    // to track if user joined as listener for first time
    _joinedOnce = false;
    // to track if user has become speaker
    _convertedToSpeaker = false;

    _currentUser =
        Provider.of<UserProvider>(context, listen: false).userDetails!;
    _hostUser = widget.roomDetails.room.creator;
    _isOwner = _currentUser.id == _hostUser.userId;
    _room = widget.roomDetails.room;

    //
    await _registerAttendee();

    // configuring agora for this room
    _initAgoraCallbacks();

    _attendees = widget.roomDetails.attendees;
    _scountAttendees();

    // listener to attendees
    FirestoreServices.attendeeStream(_room.id).listen((snapshots) {
      // todo: use docsChange of snapshot to signal change in attendee documents, test this with comments (use firebase console)

      final updatedAttendees = <Attendee>[];

      snapshots.docs.map((doc) => doc.data()).forEach((data) {
        if (data != null) {
          updatedAttendees.add(Attendee.fromJson(jsonEncode(data))!);
        }
      });
      _attendees = updatedAttendees;
      _scountAttendees();
    });

    // listener for comments
    FirestoreServices.commentStream(_room.id).listen((snapshots) {
      final newComments = <Comment>[];
      snapshots.docs.map((doc) => doc.data()).forEach((data) {
        if (data != null) {
          newComments.add(Comment.fromJson(jsonEncode(data))!);
        }
      });
      _comments = newComments;
    }, onError: (err) {
      print(err);
    });
  }

  Future<void> _handleMenuButtons(String value) async {
    switch (value) {
      case 'Join Requests':
        RightSideSheet.display(context,
            child: RoomJoinRequests(_requesters, widget.roomDetails.id));
        break;
    }
  }

  void addComment(String message) async {
    final newComment = Comment((b) => b
      ..userId = _currentUser.id
      ..username = _currentUser.username
      ..userImageUrl = _currentUser.image
      ..text = message
      ..timestamp = Timestamp.now().millisecondsSinceEpoch);
    await FirestoreServices.addNewComment(newComment, widget.roomDetails.id);
  }

  Future<bool> _kickParticpant(Attendee attendee) async {
    attendee = attendee.rebuild(
      (b) => b
        ..requestStatus = JoinRequestStatus.none
        ..isSpeaker = false,
    );
    final res = await FirestoreServices.saveAttendee(attendee, _room.id);

    Fluttertoast.showToast(msg: res ? 'Successful' : 'Unsuccessful');
    return res;
  }

  /// set [overridenMute] to true if host is muting panelist
  Future<bool> _toggleMuteOfParticpant(Attendee participant,
      [bool overridenMute = false]) async {
    // if user is unmuting himself.
    if (participant.userId == _currentUser.id) {
      var status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(
              msg: 'Please give microphone permissions from the settings');
          return false;
        }
      }
    }

    bool toMute = true;

    if (_currentAttendee.userId == participant.userId) {
      toMute = !(participant.isMuted ?? true);
    }

    String muteAction;
    if (overridenMute) {
      muteAction = 'mute';
      toMute = true;
    } else {
      muteAction = toMute ? 'mute' : 'unmute';
    }

    participant = participant.rebuild((b) => b..isMuted = toMute);

    final res = await FirestoreServices.saveAttendee(participant, _room.id,
        update: true);

    if (participant.userId == _currentAttendee.userId) {
      Provider.of<AgoraController>(context, listen: false)
          .hardMuteAction(toMute);
      _currentAttendee = _currentAttendee.rebuild((b) => b..isMuted = toMute);
    }

    Fluttertoast.showToast(msg: muteAction == 'mute' ? 'muted' : 'unmuted');

    _refreshScreen();

    return true;
  }

  void _participationButtonHandler() async {
    // user is interacting with join request button
    if (_currentAttendee.requestStatus == JoinRequestStatus.none) {
      _currentAttendee = _currentAttendee.rebuild(
        (b) => b..requestStatus = JoinRequestStatus.pending,
      );
    } else {
      _currentAttendee = _currentAttendee.rebuild(
        (b) => b..requestStatus = JoinRequestStatus.none,
      );
    }

    final res =
        await FirestoreServices.saveAttendee(_currentAttendee, _room.id);

    Fluttertoast.showToast(msg: res ? 'Successful' : 'Unsuccessful');
  }

  Future<String?> _fetchAgoraToken() async {
    final integerUsername = Provider.of<AgoraController>(context, listen: false)
        .convertToInt(_currentUser.username);

    var url = Uri.parse(
        'https://gpfcnf0xtj.execute-api.ap-south-1.amazonaws.com/test');
    var response = await http.post(url,
        body: jsonEncode(
            {'roomId': _room.id, 'uid': integerUsername.toString()}));

    final obj = jsonDecode(response.body);
    return jsonDecode(obj["body"])["agoraToken"];
  }

  @override
  void initState() {
    super.initState();
    _initiate();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentAttendee == null) {
      return LoadingWidget(withScaffold: true);
    }

    return WillPopScope(
      onWillPop: () async {
        await _disposeAgora();
        _deRegisterAttendee();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: BgGradient(
            child: Column(
              children: [
                if (_currentAttendee != null) roomDataWidget(),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      height: constraints.maxHeight -
                          MediaQuery.of(context).viewInsets.bottom,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: Colors.black,
                      child: CommentBox(
                        key: ObjectKey(_comments.length),
                        size: MediaQuery.of(context).size,
                        comments: _comments,
                        listController: _listController,
                        processTimestamp: Utilites.processTimestamp,
                        addComment: addComment,
                        newCommentController: _newCommentController,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget roomDataWidget() {
    final roomImage = _room.image;

    return Container(
      color: Colors.black87,
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: roomImage == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(roomImage),
                        fit: BoxFit.cover,
                      ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.62),
                      Colors.black.withOpacity(0.62),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.7),
                      Colors.black87,
                      Colors.black87,
                      Colors.black87,
                      Colors.black87,
                    ],
                    stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white70,
                                ),
                              ),
                              if (_isOwner == false)
                                InkWell(
                                  onTap: () => ProfileShortView.display(
                                      context, _room.creator),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.person_pin,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _hostUser.username,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isOwner == true &&
                                      _room.status == RoomStatus.live)
                                    Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        border: Border.all(
                                            color: _hasActiveJRs
                                                ? Colors.redAccent
                                                : Colors.black,
                                            width: _hasActiveJRs ? 0.5 : 0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: _hasActiveJRs ? 1 : 0,
                                            spreadRadius:
                                                _hasActiveJRs ? 0.5 : 0,
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          await _handleMenuButtons(
                                              'Join Requests');
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Join Requests',
                                              style: TextStyle(
                                                color: _hasActiveJRs
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            if (_hasActiveJRs)
                                              const Icon(
                                                Icons.circle,
                                                color: Colors.redAccent,
                                                size: 10,
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () =>
                                ClubFullDataSheet.display(context, _room),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _room.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.multitrack_audio_sharp,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _room.description ?? "(No Description)",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            SizedBox(
                              height: 100,
                              child: Center(
                                child: _showParticipantList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  LikeButton(
                    onTap: (_) async {
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        _refreshScreen();
                      });

                      if (FocusManager.instance.primaryFocus?.hasFocus ??
                          false) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }

                      return Future.value(true);
                    },
                    countDecoration: (_, count) {
                      String txt = _attendees.length.toString();
                      return Column(
                        children: [
                          Text(
                            txt,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                    isLiked: false,
                    likeCount: _attendees.length,
                    countPostion: CountPostion.bottom,
                    size: 32,
                    likeBuilder: (_) {
                      return const Icon(
                        Icons.headset,
                        color: Colors.green,
                        size: 32,
                      );
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // dedicated button for mic
                      if (_currentAttendee.isSpeaker)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _displayMicButton,
                        ),

                      // dedicated button for sending join request or stepping down to become only listener
                      if (_isOwner == false &&
                          _currentAttendee.isSpeaker == false)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _displayParticipationButton,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showParticipantList() {
    return ListView.builder(
      clipBehavior: Clip.none,
      shrinkWrap: true,
      addSemanticIndexes: false,
      itemCount: _attendees.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        //! if this is club owner
        //! different decoration for club owner

        final participant = _attendees[index];
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: ValueListenableBuilder<Map<String, int>>(
              valueListenable: currentlySpeakingUsers,
              child: _participantCardStackGesture(participant),
              builder: (context, speakers, stackGesture) {
                return Stack(
                  fit: StackFit.passthrough,
                  children: [
                    ParticipantCard(
                      participant,
                      key: ObjectKey(participant.userId + ' 2 $index'),
                      isHost: participant.userId == _hostUser.userId,
                      volume: speakers[participant.username] ?? 0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 72,
                        width: 72,
                        child: stackGesture,
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  /// due to quick updation of widgets (because of our need here), long press can't be used within listenable builder
  /// widget is re-rendered many times amidst a single timespan of long press
  /// above reasoning also satisfies doubleTap (not if double tap is done quicker than updation, which is very cumbersome here)
  /// so using a gesture detector to be stacked over main widget
  /// main widget => keeps updating, stacked gesture => remains constant so works well

  GestureDetector _participantCardStackGesture(Attendee participant) =>
      GestureDetector(
        onDoubleTap: _isOwner && participant.userId != _hostUser.userId
            ? () {
                // for non-owner participant, dialog box to show mute button
                ParticipantActionDialog.display(
                  context,
                  participant,
                  muteParticipant: _toggleMuteOfParticpant,
                  removeParticipant: _kickParticpant,
                );
              }
            : null,
        onTap: () => ProfileShortView.display(context, participant),
      );

  Widget get _displayMicButton {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: currentlySpeakingUsers,
      builder: (_, speakers, __) {
        return InkWell(
          onTap: () => _toggleMuteOfParticpant(_currentAttendee),
          child: Card(
            elevation: 4,
            shadowColor: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: _currentAttendee.isMuted == true
                  ? Colors.black87
                  : Colors.white,
              child: !(_currentAttendee.isMuted == true)
                  ? Icon(
                      Icons.mic_none_sharp,
                      color: (speakers[_currentAttendee.username] ?? 0) > 30
                          ? Colors.redAccent
                          : Colors.black,
                      size: 28,
                    )
                  : const Icon(
                      Icons.mic_off_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget get _displayParticipationButton {
    return InkWell(
      onTap: () => _participationButtonHandler(),
      child: Card(
        elevation: 4,
        shadowColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          radius: 24,
          backgroundColor:
              _currentAttendee.isSpeaker ? Colors.white : Colors.black87,
          child: Icon(
            _currentAttendee.requestStatus == JoinRequestStatus.none
                ? Icons.person_add
                : Icons.person_add_disabled,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
