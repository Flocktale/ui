import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'notificationType.g.dart';

class NotificationType extends EnumClass {
  static Serializer<NotificationType> get serializer =>
      _$notificationTypeSerializer;

  @BuiltValueEnumConst(wireName: 'FR#new')
  static const NotificationType NEW_FRIEND_REQUEST = _$NEW_FRIEND_REQUEST;

  @BuiltValueEnumConst(wireName: 'FR#accepted')
  static const NotificationType FRIEND_REQUEST_ACCEPTED =
      _$FRIEND_REQUEST_ACCEPTED;

  @BuiltValueEnumConst(wireName: 'FLW#new')
  static const NotificationType NEW_FOLLOWER = _$NEW_FOLLOWER;

  @BuiltValueEnumConst(wireName: 'CLUB#INV#prt')
  static const NotificationType CLUB_PARTICIPATION_INV =
      _$CLUB_PARTICIPATION_INV;

  @BuiltValueEnumConst(wireName: 'CLUB#INV#adc')
  static const NotificationType CLUB_AUDIENCE_INV = _$CLUB_AUDIENCE_INV;

  const NotificationType._(String name) : super(name);

  static BuiltSet<NotificationType> get values => _$values;
  static NotificationType valueOf(String name) => _$valueOf(name);
}
