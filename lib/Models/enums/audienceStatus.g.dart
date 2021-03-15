// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audienceStatus.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AudienceStatus _$Blocked = const AudienceStatus._('Blocked');
const AudienceStatus _$Participant = const AudienceStatus._('Participant');
const AudienceStatus _$ActiveJoinRequest =
    const AudienceStatus._('ActiveJoinRequest');

AudienceStatus _$valueOf(String name) {
  switch (name) {
    case 'Blocked':
      return _$Blocked;
    case 'Participant':
      return _$Participant;
    case 'ActiveJoinRequest':
      return _$ActiveJoinRequest;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AudienceStatus> _$values =
    new BuiltSet<AudienceStatus>(const <AudienceStatus>[
  _$Blocked,
  _$Participant,
  _$ActiveJoinRequest,
]);

Serializer<AudienceStatus> _$audienceStatusSerializer =
    new _$AudienceStatusSerializer();

class _$AudienceStatusSerializer
    implements PrimitiveSerializer<AudienceStatus> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'Blocked': 'Blocked',
    'Participant': 'Participant',
    'ActiveJoinRequest': 'ActiveJoinRequest',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Blocked': 'Blocked',
    'Participant': 'Participant',
    'ActiveJoinRequest': 'ActiveJoinRequest',
  };

  @override
  final Iterable<Type> types = const <Type>[AudienceStatus];
  @override
  final String wireName = 'AudienceStatus';

  @override
  Object serialize(Serializers serializers, AudienceStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudienceStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudienceStatus.valueOf(_fromWire[serialized] ?? serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
