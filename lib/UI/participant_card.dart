import 'package:flutter/material.dart';
import 'package:talkitup/Models/attendee.dart';

class ParticipantCard extends StatelessWidget {
  final Attendee participant;
  final bool isHost;

  final int volume;

  const ParticipantCard(
    this.participant, {
    required Key key,
    this.isHost = false,
    this.volume = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: volume < 20
                        ? null
                        : [
                            if (volume > 200)
                              const BoxShadow(
                                color: Colors.redAccent,
                                spreadRadius: 3,
                                blurRadius: 6,
                              ),
                            BoxShadow(
                              color: Colors.green,
                              spreadRadius: volume > 200
                                  ? 2
                                  : (volume > 100 ? 3 : volume / 40),
                              blurRadius: volume > 200
                                  ? 3
                                  : (volume > 100 ? 3 : volume / 40),
                            ),
                            BoxShadow(
                              color: Colors.yellow,
                              spreadRadius: volume < 100 ? 1 : 0.5,
                            ),
                          ],
                    image: participant.image == null
                        ? null
                        : DecorationImage(
                            image: NetworkImage(participant.image!),
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: participant.isMuted == true
                      ? Colors.black.withOpacity(0.5)
                      : Colors.green.withOpacity(0.5),
                  radius: 10,
                  child: Icon(
                    participant.isMuted == true
                        ? Icons.mic_off_outlined
                        : Icons.mic_none_sharp,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 84,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  participant.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ],
    );
  }
}
