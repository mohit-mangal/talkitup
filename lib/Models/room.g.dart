// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Room> _$roomSerializer = new _$RoomSerializer();

class _$RoomSerializer implements StructuredSerializer<Room> {
  @override
  final Iterable<Type> types = const [Room, _$Room];
  @override
  final String wireName = 'Room';

  @override
  Iterable<Object?> serialize(Serializers serializers, Room object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'creator',
      serializers.serialize(object.creator,
          specifiedType: const FullType(Attendee)),
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(RoomStatus)),
    ];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Room deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RoomBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creator':
          result.creator.replace(serializers.deserialize(value,
              specifiedType: const FullType(Attendee))! as Attendee);
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(RoomStatus)) as RoomStatus;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Room extends Room {
  @override
  final String id;
  @override
  final Attendee creator;
  @override
  final String title;
  @override
  final RoomStatus status;
  @override
  final String? description;
  @override
  final String? image;

  factory _$Room([void Function(RoomBuilder)? updates]) =>
      (new RoomBuilder()..update(updates)).build();

  _$Room._(
      {required this.id,
      required this.creator,
      required this.title,
      required this.status,
      this.description,
      this.image})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'Room', 'id');
    BuiltValueNullFieldError.checkNotNull(creator, 'Room', 'creator');
    BuiltValueNullFieldError.checkNotNull(title, 'Room', 'title');
    BuiltValueNullFieldError.checkNotNull(status, 'Room', 'status');
  }

  @override
  Room rebuild(void Function(RoomBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomBuilder toBuilder() => new RoomBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Room &&
        id == other.id &&
        creator == other.creator &&
        title == other.title &&
        status == other.status &&
        description == other.description &&
        image == other.image;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, id.hashCode), creator.hashCode), title.hashCode),
                status.hashCode),
            description.hashCode),
        image.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Room')
          ..add('id', id)
          ..add('creator', creator)
          ..add('title', title)
          ..add('status', status)
          ..add('description', description)
          ..add('image', image))
        .toString();
  }
}

class RoomBuilder implements Builder<Room, RoomBuilder> {
  _$Room? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AttendeeBuilder? _creator;
  AttendeeBuilder get creator => _$this._creator ??= new AttendeeBuilder();
  set creator(AttendeeBuilder? creator) => _$this._creator = creator;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  RoomStatus? _status;
  RoomStatus? get status => _$this._status;
  set status(RoomStatus? status) => _$this._status = status;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  RoomBuilder();

  RoomBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _creator = $v.creator.toBuilder();
      _title = $v.title;
      _status = $v.status;
      _description = $v.description;
      _image = $v.image;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Room other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Room;
  }

  @override
  void update(void Function(RoomBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Room build() {
    _$Room _$result;
    try {
      _$result = _$v ??
          new _$Room._(
              id: BuiltValueNullFieldError.checkNotNull(id, 'Room', 'id'),
              creator: creator.build(),
              title:
                  BuiltValueNullFieldError.checkNotNull(title, 'Room', 'title'),
              status: BuiltValueNullFieldError.checkNotNull(
                  status, 'Room', 'status'),
              description: description,
              image: image);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'creator';
        creator.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Room', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
