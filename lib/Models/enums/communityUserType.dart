import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'communityUserType.g.dart';

class CommunityUserType extends EnumClass {
  static Serializer<CommunityUserType> get serializer =>
      _$communityUserTypeSerializer;

  @BuiltValueEnumConst(wireName: 'HOST')
  static const CommunityUserType HOST = _$HOST;

  @BuiltValueEnumConst(wireName: 'MEMBER')
  static const CommunityUserType MEMBER = _$MEMBER;

  const CommunityUserType._(String name) : super(name);

  static BuiltSet<CommunityUserType> get values => _$values;
  static CommunityUserType valueOf(String name) => _$valueOf(name);
}
