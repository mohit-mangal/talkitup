import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'room_status.g.dart';

class RoomStatus extends EnumClass {
  const RoomStatus._(String name) : super(name);

  @BuiltValueEnumConst(wireName: 'LIVE')
  static const RoomStatus live = _$LIVE;

  @BuiltValueEnumConst(wireName: 'FINISHED')
  static const RoomStatus finished = _$FINISHED;

  @BuiltValueEnumConst(wireName: 'FUTURE')
  static const RoomStatus future = _$FUTURE;

  static Serializer<RoomStatus> get serializer => _$roomStatusSerializer;
  static BuiltSet<RoomStatus> get values => _$values;
  static RoomStatus valueOf(String name) => _$valueOf(name);
}
