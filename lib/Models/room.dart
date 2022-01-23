import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:talkitup/Models/Enums/room_status.dart';
import 'package:talkitup/Models/attendee.dart';

import 'api_serializers.dart';

part 'room.g.dart';

abstract class Room implements Built<Room, RoomBuilder> {
  // fields go here

  Room._();

  String get id;
  Attendee get creator;

  String get title;

  RoomStatus get status;

  String? get description;

  String? get image;

  factory Room([updates(RoomBuilder b)]) = _$Room;

  String toJson() {
    return json.encode(serializers.serializeWith(Room.serializer, this));
  }

  static Room? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Room.serializer, json.decode(jsonString));
  }

  static Serializer<Room> get serializer => _$roomSerializer;
}
