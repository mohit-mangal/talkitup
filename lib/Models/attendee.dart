import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'Enums/join_request_status.dart';
import 'api_serializers.dart';

part 'attendee.g.dart';

abstract class Attendee implements Built<Attendee, AttendeeBuilder> {
  // fields go here

  Attendee._();
  String get userId;
  String get username;
  String get name;
  String? get image;

  bool get isSpeaker;
  bool? get isMuted;

  int get timestamp;

  JoinRequestStatus get requestStatus;

  factory Attendee([updates(AttendeeBuilder b)]) = _$Attendee;

  String toJson() {
    return json.encode(serializers.serializeWith(Attendee.serializer, this));
  }

  static Attendee? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Attendee.serializer, json.decode(jsonString));
  }

  static Serializer<Attendee> get serializer => _$attendeeSerializer;
}
