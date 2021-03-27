// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communityUserType.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CommunityUserType _$HOST = const CommunityUserType._('HOST');
const CommunityUserType _$MEMBER = const CommunityUserType._('MEMBER');

CommunityUserType _$valueOf(String name) {
  switch (name) {
    case 'HOST':
      return _$HOST;
    case 'MEMBER':
      return _$MEMBER;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<CommunityUserType> _$values =
    new BuiltSet<CommunityUserType>(const <CommunityUserType>[
  _$HOST,
  _$MEMBER,
]);

Serializer<CommunityUserType> _$communityUserTypeSerializer =
    new _$CommunityUserTypeSerializer();

class _$CommunityUserTypeSerializer
    implements PrimitiveSerializer<CommunityUserType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HOST': 'HOST',
    'MEMBER': 'MEMBER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HOST': 'HOST',
    'MEMBER': 'MEMBER',
  };

  @override
  final Iterable<Type> types = const <Type>[CommunityUserType];
  @override
  final String wireName = 'CommunityUserType';

  @override
  Object serialize(Serializers serializers, CommunityUserType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CommunityUserType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CommunityUserType.valueOf(_fromWire[serialized] ?? serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
