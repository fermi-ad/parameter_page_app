// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i1;

part 'get_device_info.var.gql.g.dart';

abstract class GGetDeviceInfoVars
    implements Built<GGetDeviceInfoVars, GGetDeviceInfoVarsBuilder> {
  GGetDeviceInfoVars._();

  factory GGetDeviceInfoVars([Function(GGetDeviceInfoVarsBuilder b) updates]) =
      _$GGetDeviceInfoVars;

  BuiltList<String> get names;
  static Serializer<GGetDeviceInfoVars> get serializer =>
      _$gGetDeviceInfoVarsSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoVars.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoVars.serializer,
        json,
      );
}
