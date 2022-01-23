// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserDetails> _$userDetailsSerializer = new _$UserDetailsSerializer();

class _$UserDetailsSerializer implements StructuredSerializer<UserDetails> {
  @override
  final Iterable<Type> types = const [UserDetails, _$UserDetails];
  @override
  final String wireName = 'UserDetails';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserDetails object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'username',
      serializers.serialize(object.username,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.tagline;
    if (value != null) {
      result
        ..add('tagline')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.bio;
    if (value != null) {
      result
        ..add('bio')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UserDetails deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UserDetailsBuilder();

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
        case 'username':
          result.username = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'tagline':
          result.tagline = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'bio':
          result.bio = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$UserDetails extends UserDetails {
  @override
  final String id;
  @override
  final String username;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? image;
  @override
  final String? tagline;
  @override
  final String? bio;

  factory _$UserDetails([void Function(UserDetailsBuilder)? updates]) =>
      (new UserDetailsBuilder()..update(updates)).build();

  _$UserDetails._(
      {required this.id,
      required this.username,
      required this.name,
      required this.email,
      this.image,
      this.tagline,
      this.bio})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'UserDetails', 'id');
    BuiltValueNullFieldError.checkNotNull(username, 'UserDetails', 'username');
    BuiltValueNullFieldError.checkNotNull(name, 'UserDetails', 'name');
    BuiltValueNullFieldError.checkNotNull(email, 'UserDetails', 'email');
  }

  @override
  UserDetails rebuild(void Function(UserDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserDetailsBuilder toBuilder() => new UserDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDetails &&
        id == other.id &&
        username == other.username &&
        name == other.name &&
        email == other.email &&
        image == other.image &&
        tagline == other.tagline &&
        bio == other.bio;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), username.hashCode),
                        name.hashCode),
                    email.hashCode),
                image.hashCode),
            tagline.hashCode),
        bio.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserDetails')
          ..add('id', id)
          ..add('username', username)
          ..add('name', name)
          ..add('email', email)
          ..add('image', image)
          ..add('tagline', tagline)
          ..add('bio', bio))
        .toString();
  }
}

class UserDetailsBuilder implements Builder<UserDetails, UserDetailsBuilder> {
  _$UserDetails? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  String? _tagline;
  String? get tagline => _$this._tagline;
  set tagline(String? tagline) => _$this._tagline = tagline;

  String? _bio;
  String? get bio => _$this._bio;
  set bio(String? bio) => _$this._bio = bio;

  UserDetailsBuilder();

  UserDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _name = $v.name;
      _email = $v.email;
      _image = $v.image;
      _tagline = $v.tagline;
      _bio = $v.bio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserDetails other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$UserDetails;
  }

  @override
  void update(void Function(UserDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserDetails build() {
    final _$result = _$v ??
        new _$UserDetails._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'UserDetails', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
                username, 'UserDetails', 'username'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'UserDetails', 'name'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, 'UserDetails', 'email'),
            image: image,
            tagline: tagline,
            bio: bio);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
