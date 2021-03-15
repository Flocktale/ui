import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'clubStatus.g.dart';

class ClubStatus extends EnumClass {
  static Serializer<ClubStatus> get serializer => _$clubStatusSerializer;

  @BuiltValueEnumConst(wireName: 'Live')
  static const ClubStatus Live = _$Live;

  @BuiltValueEnumConst(wireName: 'Waiting')
  static const ClubStatus Waiting = _$Waiting;

  @BuiltValueEnumConst(wireName: 'Concluded')
  static const ClubStatus Concluded = _$Concluded;

  const ClubStatus._(String name) : super(name);

  static BuiltSet<ClubStatus> get values => _$values;
  static ClubStatus valueOf(String name) => _$valueOf(name);
}
