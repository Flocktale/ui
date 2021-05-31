import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'queryType.g.dart';

class QueryType extends EnumClass {
  static Serializer<QueryType> get serializer => _$queryTypeSerializer;

  @BuiltValueEnumConst(wireName: 'unified')
  static const QueryType unified = _$unified;

  @BuiltValueEnumConst(wireName: 'clubs')
  static const QueryType clubs = _$clubs;

  @BuiltValueEnumConst(wireName: 'users')
  static const QueryType users = _$users;

  @BuiltValueEnumConst(wireName: 'communities')
  static const QueryType communities = _$communities;

  const QueryType._(String name) : super(name);

  static BuiltSet<QueryType> get values => _$values;
  static QueryType valueOf(String name) => _$valueOf(name);
}
