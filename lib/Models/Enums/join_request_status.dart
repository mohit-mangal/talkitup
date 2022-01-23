import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'join_request_status.g.dart';

class JoinRequestStatus extends EnumClass {
  const JoinRequestStatus._(String name) : super(name);

  @BuiltValueEnumConst(wireName: 'PENDING')
  static const JoinRequestStatus pending = _$PENDING;

  @BuiltValueEnumConst(wireName: 'ACCEPTED')
  static const JoinRequestStatus accepted = _$ACCEPTED;

  @BuiltValueEnumConst(wireName: 'NONE')
  static const JoinRequestStatus none = _$NONE;

  static Serializer<JoinRequestStatus> get serializer =>
      _$joinRequestStatusSerializer;
  static BuiltSet<JoinRequestStatus> get values => _$values;
  static JoinRequestStatus valueOf(String name) => _$valueOf(name);
}
