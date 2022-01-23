import 'package:talkitup/Models/attendee.dart';
import 'package:talkitup/Models/comment.dart';
import 'package:talkitup/Models/room.dart';

class RoomDetails {
  late String id;
  Room room;
  List<Attendee> attendees = [];
  List<Comment> comments = [];
  RoomDetails(this.room) {
    id = room.id;
  }
}
