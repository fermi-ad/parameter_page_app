// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i1;

part 'DPM.schema.gql.g.dart';

abstract class GDevValue implements Built<GDevValue, GDevValueBuilder> {
  GDevValue._();

  factory GDevValue([Function(GDevValueBuilder b) updates]) = _$GDevValue;

  int? get intVal;
  double? get scalarVal;
  BuiltList<double>? get scalarArrayVal;
  BuiltList<int>? get rawVal;
  String? get textVal;
  BuiltList<String>? get textArrayVal;
  static Serializer<GDevValue> get serializer => _$gDevValueSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GDevValue.serializer,
        this,
      ) as Map<String, dynamic>);
  static GDevValue? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GDevValue.serializer,
        json,
      );
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
  },
  'DeviceInfoResult': {
    'DeviceInfo',
    'ErrorReply',
  },
};
