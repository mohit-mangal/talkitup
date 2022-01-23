import 'package:flutter/material.dart';
import 'package:talkitup/Models/room.dart';
import 'package:talkitup/UI/shareApp.dart';

class ClubFullDataSheet extends StatelessWidget {
  static void display(BuildContext context, Room room) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (_, controller) => ClubFullDataSheet(
          controller: controller,
          room: room,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  final Room room;
  final ScrollController controller;

  const ClubFullDataSheet(
      {Key? key, required this.room, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView(
        controller: controller,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 192,
            decoration: BoxDecoration(
              image: room.image == null
                  ? null
                  : DecorationImage(
                      image: NetworkImage(room.image!),
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            room.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
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
                  room.description ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Card(
              elevation: 2,
              shadowColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () => ShareApp(context).club(room.title),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.share,
                        size: 24,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Share with your friends',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
