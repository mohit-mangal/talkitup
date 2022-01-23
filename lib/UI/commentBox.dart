import 'package:flutter/material.dart';
import 'package:talkitup/Models/Enums/join_request_status.dart';
import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/comment.dart';

import 'ProfileShortView.dart';

class CommentBox extends StatelessWidget {
  final Size size;
  final List<Comment> comments;
  final ScrollController listController;

  final Function(int, int) processTimestamp;
  final Function(String) addComment;

  final TextEditingController newCommentController;

  CommentBox({
    Key? key,
    required this.size,
    required this.comments,
    required this.listController,
    required this.processTimestamp,
    required this.addComment,
    required this.newCommentController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              width: size.width,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: comments.length,
                  controller: listController,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    bool continuation = false;
                    if (index != comments.length - 1) {
                      if (comment.userId == comments[index + 1].userId) {
                        continuation = true;
                      }
                    }

                    return Container(
                      margin: EdgeInsets.only(
                          bottom: continuation ? 0 : 12, right: 32, top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          continuation
                              ? const SizedBox(width: 36)
                              : GestureDetector(
                                  onTap: () {
                                    Attendee attendee = Attendee((b) => b
                                      ..userId = comment.userId
                                      ..username = comment.username
                                      ..name = ''
                                      ..image = comment.userImageUrl
                                      ..isSpeaker = false
                                      ..timestamp = comment.timestamp
                                      ..requestStatus = JoinRequestStatus.none);
                                    ProfileShortView.display(context, attendee);
                                  },
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: comment.userImageUrl == null
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(
                                                  comment.userImageUrl!),
                                            ),
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 8),
                          Flexible(
                              child: Card(
                            elevation: 1,
                            shadowColor: Colors.redAccent,
                            color: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.text,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${continuation ? "" : comment.username} · ${processTimestamp(comment.timestamp, 1)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            width: size.width,
            child: TextField(
              controller: newCommentController,
              minLines: 1,
              maxLines: 3,
              cursorColor: Colors.redAccent,
              scrollPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              textInputAction: TextInputAction.newline,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    addComment(newCommentController.text);

                    newCommentController.text = '';
                  },
                ),
                hintStyle: const TextStyle(color: Colors.white38),
                fillColor: Colors.white10,
                hintText: "Type what's in your mind",
                filled: true,
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white12, width: 0.5)),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white12, width: 0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
