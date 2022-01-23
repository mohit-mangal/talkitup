// Package imports:
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:talkitup/Models/Enums/join_request_status.dart';
import 'package:talkitup/Models/Enums/room_status.dart';
import 'package:talkitup/Models/room.dart';

import 'attendee.dart';
import 'comment.dart';
import 'user_details.dart';

// Project imports:

part 'api_serializers.g.dart';

@SerializersFor([
  Comment,
  Room,
  UserDetails,
  Attendee,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
