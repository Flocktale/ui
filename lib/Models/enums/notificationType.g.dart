// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationType.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationType _$NEW_FRIEND_REQUEST =
    const NotificationType._('NEW_FRIEND_REQUEST');
const NotificationType _$FRIEND_REQUEST_ACCEPTED =
    const NotificationType._('FRIEND_REQUEST_ACCEPTED');
const NotificationType _$NEW_FOLLOWER =
    const NotificationType._('NEW_FOLLOWER');
const NotificationType _$CLUB_PARTICIPATION_INV =
    const NotificationType._('CLUB_PARTICIPATION_INV');
const NotificationType _$CLUB_AUDIENCE_INV =
    const NotificationType._('CLUB_AUDIENCE_INV');

NotificationType _$valueOf(String name) {
  switch (name) {
    case 'NEW_FRIEND_REQUEST':
      return _$NEW_FRIEND_REQUEST;
    case 'FRIEND_REQUEST_ACCEPTED':
      return _$FRIEND_REQUEST_ACCEPTED;
    case 'NEW_FOLLOWER':
      return _$NEW_FOLLOWER;
    case 'CLUB_PARTICIPATION_INV':
      return _$CLUB_PARTICIPATION_INV;
    case 'CLUB_AUDIENCE_INV':
      return _$CLUB_AUDIENCE_INV;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<NotificationType> _$values =
    new BuiltSet<NotificationType>(const <NotificationType>[
  _$NEW_FRIEND_REQUEST,
  _$FRIEND_REQUEST_ACCEPTED,
  _$NEW_FOLLOWER,
  _$CLUB_PARTICIPATION_INV,
  _$CLUB_AUDIENCE_INV,
]);

Serializer<NotificationType> _$notificationTypeSerializer =
    new _$NotificationTypeSerializer();

class _$NotificationTypeSerializer
    implements PrimitiveSerializer<NotificationType> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NEW_FRIEND_REQUEST': 'FR#new',
    'FRIEND_REQUEST_ACCEPTED': 'FR#accepted',
    'NEW_FOLLOWER': 'FLW#new',
    'CLUB_PARTICIPATION_INV': 'CLUB#INV#prt',
    'CLUB_AUDIENCE_INV': 'CLUB#INV#adc',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FR#new': 'NEW_FRIEND_REQUEST',
    'FR#accepted': 'FRIEND_REQUEST_ACCEPTED',
    'FLW#new': 'NEW_FOLLOWER',
    'CLUB#INV#prt': 'CLUB_PARTICIPATION_INV',
    'CLUB#INV#adc': 'CLUB_AUDIENCE_INV',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationType];
  @override
  final String wireName = 'NotificationType';

  @override
  Object serialize(Serializers serializers, NotificationType object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationType deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationType.valueOf(_fromWire[serialized] ?? serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
