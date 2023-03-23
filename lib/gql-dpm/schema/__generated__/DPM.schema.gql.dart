// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gql_code_builder/src/serializers/default_scalar_serializer.dart'
    as _i1;

part 'DPM.schema.gql.g.dart';

abstract class GTimestamp implements Built<GTimestamp, GTimestampBuilder> {
  GTimestamp._();

  factory GTimestamp([String? value]) =>
      _$GTimestamp((b) => value != null ? (b..value = value) : b);

  String get value;
  @BuiltValueSerializer(custom: true)
  static Serializer<GTimestamp> get serializer =>
      _i1.DefaultScalarSerializer<GTimestamp>(
          (Object serialized) => GTimestamp((serialized as String?)));
}

const Map<String, Set<String>> possibleTypesMap = {
  'DataType': {
    'StatusReply',
    'Scalar',
    'ScalarArray',
    'Raw',
    'Text',
    'TextArray',
    'StructData',
  }
};
