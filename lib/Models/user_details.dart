import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'api_serializers.dart';

part 'user_details.g.dart';

abstract class UserDetails implements Built<UserDetails, UserDetailsBuilder> {
  // fields go here

  UserDetails._();
  String get id;
  String get username;
  String get name;
  String get email;

  String? get image;

  String? get tagline;
  String? get bio;

  factory UserDetails([updates(UserDetailsBuilder b)]) = _$UserDetails;

  String toJson() {
    return json.encode(serializers.serializeWith(UserDetails.serializer, this));
  }

  static UserDetails? fromJson(String jsonString) {
    return serializers.deserializeWith(
        UserDetails.serializer, json.decode(jsonString));
  }

  static Serializer<UserDetails> get serializer => _$userDetailsSerializer;
}
