// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RoomStatus _$LIVE = const RoomStatus._('live');
const RoomStatus _$FINISHED = const RoomStatus._('finished');
const RoomStatus _$FUTURE = const RoomStatus._('future');

RoomStatus _$valueOf(String name) {
  switch (name) {
    case 'live':
      return _$LIVE;
    case 'finished':
      return _$FINISHED;
    case 'future':
      return _$FUTURE;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RoomStatus> _$values =
    new BuiltSet<RoomStatus>(const <RoomStatus>[
  _$LIVE,
  _$FINISHED,
  _$FUTURE,
]);

Serializer<RoomStatus> _$roomStatusSerializer = new _$RoomStatusSerializer();

class _$RoomStatusSerializer implements PrimitiveSerializer<RoomStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'live': 'LIVE',
    'finished': 'FINISHED',
    'future': 'FUTURE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LIVE': 'live',
    'FINISHED': 'finished',
    'FUTURE': 'future',
  };

  @override
  final Iterable<Type> types = const <Type>[RoomStatus];
  @override
  final String wireName = 'RoomStatus';

  @override
  Object serialize(Serializers serializers, RoomStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RoomStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RoomStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
