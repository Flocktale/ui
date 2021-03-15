import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'audienceStatus.g.dart';

class AudienceStatus extends EnumClass {
  static Serializer<AudienceStatus> get serializer =>
      _$audienceStatusSerializer;

  @BuiltValueEnumConst(wireName: 'Blocked')
  static const AudienceStatus Blocked = _$Blocked;

  @BuiltValueEnumConst(wireName: 'Participant')
  static const AudienceStatus Participant = _$Participant;

  @BuiltValueEnumConst(wireName: 'ActiveJoinRequest')
  static const AudienceStatus ActiveJoinRequest = _$ActiveJoinRequest;

  const AudienceStatus._(String name) : super(name);

  static BuiltSet<AudienceStatus> get values => _$values;
  static AudienceStatus valueOf(String name) => _$valueOf(name);
}
