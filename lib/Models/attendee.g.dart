// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendee.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Attendee> _$attendeeSerializer = new _$AttendeeSerializer();

class _$AttendeeSerializer implements StructuredSerializer<Attendee> {
  @override
  final Iterable<Type> types = const [Attendee, _$Attendee];
  @override
  final String wireName = 'Attendee';

  @override
  Iterable<Object?> serialize(Serializers serializers, Attendee object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'isSpeaker',
      serializers.serialize(object.isSpeaker,
          specifiedType: const FullType(bool)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(int)),
      'requestStatus',
      serializers.serialize(object.requestStatus,
          specifiedType: const FullType(JoinRequestStatus)),
    ];
    Object? value;
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isMuted;
    if (value != null) {
      result
        ..add('isMuted')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Attendee deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AttendeeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'isSpeaker':
          result.isSpeaker = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isMuted':
          result.isMuted = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'requestStatus':
          result.requestStatus = serializers.deserialize(value,
                  specifiedType: const FullType(JoinRequestStatus))
              as JoinRequestStatus;
          break;
      }
    }

    return result.build();
  }
}

class _$Attendee extends Attendee {
  @override
  final String userId;
  @override
  final String username;
  @override
  final String name;
  @override
  final String? image;
  @override
  final bool isSpeaker;
  @override
  final bool? isMuted;
  @override
  final int timestamp;
  @override
  final JoinRequestStatus requestStatus;

  factory _$Attendee([void Function(AttendeeBuilder)? updates]) =>
      (new AttendeeBuilder()..update(updates)).build();

  _$Attendee._(
      {required this.userId,
      required this.username,
      required this.name,
      this.image,
      required this.isSpeaker,
      this.isMuted,
      required this.timestamp,
      required this.requestStatus})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, 'Attendee', 'userId');
    BuiltValueNullFieldError.checkNotNull(username, 'Attendee', 'username');
    BuiltValueNullFieldError.checkNotNull(name, 'Attendee', 'name');
    BuiltValueNullFieldError.checkNotNull(isSpeaker, 'Attendee', 'isSpeaker');
    BuiltValueNullFieldError.checkNotNull(timestamp, 'Attendee', 'timestamp');
    BuiltValueNullFieldError.checkNotNull(
        requestStatus, 'Attendee', 'requestStatus');
  }

  @override
  Attendee rebuild(void Function(AttendeeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendeeBuilder toBuilder() => new AttendeeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Attendee &&
        userId == other.userId &&
        username == other.username &&
        name == other.name &&
        image == other.image &&
        isSpeaker == other.isSpeaker &&
        isMuted == other.isMuted &&
        timestamp == other.timestamp &&
        requestStatus == other.requestStatus;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, userId.hashCode), username.hashCode),
                            name.hashCode),
                        image.hashCode),
                    isSpeaker.hashCode),
                isMuted.hashCode),
            timestamp.hashCode),
        requestStatus.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Attendee')
          ..add('userId', userId)
          ..add('username', username)
          ..add('name', name)
          ..add('image', image)
          ..add('isSpeaker', isSpeaker)
          ..add('isMuted', isMuted)
          ..add('timestamp', timestamp)
          ..add('requestStatus', requestStatus))
        .toString();
  }
}

class AttendeeBuilder implements Builder<Attendee, AttendeeBuilder> {
  _$Attendee? _$v;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _isSpeaker;
  bool? get isSpeaker => _$this._isSpeaker;
  set isSpeaker(bool? isSpeaker) => _$this._isSpeaker = isSpeaker;

  bool? _isMuted;
  bool? get isMuted => _$this._isMuted;
  set isMuted(bool? isMuted) => _$this._isMuted = isMuted;

  int? _timestamp;
  int? get timestamp => _$this._timestamp;
  set timestamp(int? timestamp) => _$this._timestamp = timestamp;

  JoinRequestStatus? _requestStatus;
  JoinRequestStatus? get requestStatus => _$this._requestStatus;
  set requestStatus(JoinRequestStatus? requestStatus) =>
      _$this._requestStatus = requestStatus;

  AttendeeBuilder();

  AttendeeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _username = $v.username;
      _name = $v.name;
      _image = $v.image;
      _isSpeaker = $v.isSpeaker;
      _isMuted = $v.isMuted;
      _timestamp = $v.timestamp;
      _requestStatus = $v.requestStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Attendee other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Attendee;
  }

  @override
  void update(void Function(AttendeeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Attendee build() {
    final _$result = _$v ??
        new _$Attendee._(
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, 'Attendee', 'userId'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, 'Attendee', 'username'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, 'Attendee', 'name'),
            image: image,
            isSpeaker: BuiltValueNullFieldError.checkNotNull(
                isSpeaker, 'Attendee', 'isSpeaker'),
            isMuted: isMuted,
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, 'Attendee', 'timestamp'),
            requestStatus: BuiltValueNullFieldError.checkNotNull(
                requestStatus, 'Attendee', 'requestStatus'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
