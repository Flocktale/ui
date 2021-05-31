// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queryType.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const QueryType _$unified = const QueryType._('unified');
const QueryType _$clubs = const QueryType._('clubs');
const QueryType _$users = const QueryType._('users');
const QueryType _$communities = const QueryType._('communities');

QueryType _$valueOf(String name) {
  switch (name) {
    case 'unified':
      return _$unified;
    case 'clubs':
      return _$clubs;
    case 'users':
      return _$users;
    case 'communities':
      return _$communities;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<QueryType> _$values = new BuiltSet<QueryType>(const <QueryType>[
  _$unified,
  _$clubs,
  _$users,
  _$communities,
]);

Serializer<QueryType> _$queryTypeSerializer = new _$QueryTypeSerializer();

class _$QueryTypeSerializer implements PrimitiveSerializer<QueryType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'unified': 'unified',
    'clubs': 'clubs',
    'users': 'users',
    'communities': 'communities',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'unified': 'unified',
    'clubs': 'clubs',
    'users': 'users',
    'communities': 'communities',
  };

  @override
  final Iterable<Type> types = const <Type>[QueryType];
  @override
  final String wireName = 'QueryType';

  @override
  Object serialize(Serializers serializers, QueryType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  QueryType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      QueryType.valueOf(_fromWire[serialized] ?? serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
