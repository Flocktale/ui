// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubStatus.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClubStatus _$Live = const ClubStatus._('Live');
const ClubStatus _$Waiting = const ClubStatus._('Waiting');
const ClubStatus _$Concluded = const ClubStatus._('Concluded');

ClubStatus _$valueOf(String name) {
  switch (name) {
    case 'Live':
      return _$Live;
    case 'Waiting':
      return _$Waiting;
    case 'Concluded':
      return _$Concluded;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ClubStatus> _$values =
    new BuiltSet<ClubStatus>(const <ClubStatus>[
  _$Live,
  _$Waiting,
  _$Concluded,
]);

Serializer<ClubStatus> _$clubStatusSerializer = new _$ClubStatusSerializer();

class _$ClubStatusSerializer implements PrimitiveSerializer<ClubStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'Live': 'Live',
    'Waiting': 'Waiting',
    'Concluded': 'Concluded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Live': 'Live',
    'Waiting': 'Waiting',
    'Concluded': 'Concluded',
  };

  @override
  final Iterable<Type> types = const <Type>[ClubStatus];
  @override
  final String wireName = 'ClubStatus';

  @override
  Object serialize(Serializers serializers, ClubStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClubStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClubStatus.valueOf(_fromWire[serialized] ?? serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
