import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'api_serializers.dart';

part 'comment.g.dart';

abstract class Comment implements Built<Comment, CommentBuilder> {
  // fields go here

  Comment._();

  String get userId;
  String get username;
  String? get userImageUrl;
  String get text;
  int get timestamp;

  factory Comment([updates(CommentBuilder b)]) = _$Comment;

  String toJson() {
    return json.encode(serializers.serializeWith(Comment.serializer, this));
  }

  static Comment? fromJson(String jsonString) {
    return serializers.deserializeWith(
        Comment.serializer, json.decode(jsonString));
  }

  static Serializer<Comment> get serializer => _$commentSerializer;
}
