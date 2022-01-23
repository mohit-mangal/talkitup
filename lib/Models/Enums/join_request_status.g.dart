// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_request_status.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const JoinRequestStatus _$PENDING = const JoinRequestStatus._('pending');
const JoinRequestStatus _$ACCEPTED = const JoinRequestStatus._('accepted');
const JoinRequestStatus _$NONE = const JoinRequestStatus._('none');

JoinRequestStatus _$valueOf(String name) {
  switch (name) {
    case 'pending':
      return _$PENDING;
    case 'accepted':
      return _$ACCEPTED;
    case 'none':
      return _$NONE;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<JoinRequestStatus> _$values =
    new BuiltSet<JoinRequestStatus>(const <JoinRequestStatus>[
  _$PENDING,
  _$ACCEPTED,
  _$NONE,
]);

Serializer<JoinRequestStatus> _$joinRequestStatusSerializer =
    new _$JoinRequestStatusSerializer();

class _$JoinRequestStatusSerializer
    implements PrimitiveSerializer<JoinRequestStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'PENDING',
    'accepted': 'ACCEPTED',
    'none': 'NONE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'pending',
    'ACCEPTED': 'accepted',
    'NONE': 'none',
  };

  @override
  final Iterable<Type> types = const <Type>[JoinRequestStatus];
  @override
  final String wireName = 'JoinRequestStatus';

  @override
  Object serialize(Serializers serializers, JoinRequestStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  JoinRequestStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      JoinRequestStatus.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
