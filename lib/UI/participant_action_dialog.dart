import 'package:flutter/material.dart';
import 'package:talkitup/Models/attendee.dart';

import 'imageDialogLayout.dart';

class ParticipantActionDialog extends StatefulWidget {
  static void display(
    BuildContext context,
    Attendee participant, {
    required Future<bool> Function(Attendee) muteParticipant,
    required Future<bool> Function(Attendee) removeParticipant,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (ctx) => ParticipantActionDialog(
        participant,
        muteParticipant: muteParticipant,
        removeParticipant: removeParticipant,
      ),
    );
  }

  final Future<bool> Function(Attendee) muteParticipant;
  final Future<bool> Function(Attendee) removeParticipant;

  final Attendee participant;
  const ParticipantActionDialog(
    this.participant, {
    required this.muteParticipant,
    required this.removeParticipant,
  });
  @override
  _ParticipantActionDialogState createState() =>
      _ParticipantActionDialogState();
}

class _ParticipantActionDialogState extends State<ParticipantActionDialog> {
  late Attendee _participant;
  @override
  void initState() {
    this._participant = widget.participant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImageDialogLayout(
      imageUrl: _participant.image,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _participant.username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        splashColor: Colors.redAccent,
                        onTap: _participant.isMuted == true
                            ? null
                            : () async {
                                final res =
                                    await widget.muteParticipant(_participant);
                                if (res == true) {
                                  setState(() {
                                    _participant = _participant
                                        .rebuild((b) => b..isMuted = true);
                                  });
                                }
                              },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: _participant.isMuted == true
                              ? Colors.black87
                              : Colors.white,
                          child: Icon(
                            _participant.isMuted == true
                                ? Icons.mic_off_sharp
                                : Icons.mic_none_sharp,
                            size: 36,
                            color: _participant.isMuted == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mute${_participant.isMuted == true ? 'd' : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: _participant.isMuted == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.black,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onLongPress: () async {
                      final res = await widget.removeParticipant(_participant);
                      if (res == true) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.redAccent,
                      color: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: const Text(
                          'Demote',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    '( long press )',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    '( to listener only )',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
