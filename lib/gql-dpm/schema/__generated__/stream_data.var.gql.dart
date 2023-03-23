// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i1;

part 'stream_data.var.gql.g.dart';

abstract class GStreamDataVars
    implements Built<GStreamDataVars, GStreamDataVarsBuilder> {
  GStreamDataVars._();

  factory GStreamDataVars([Function(GStreamDataVarsBuilder b) updates]) =
      _$GStreamDataVars;

  BuiltList<String> get drfs;
  static Serializer<GStreamDataVars> get serializer =>
      _$gStreamDataVarsSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataVars.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataVars? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataVars.serializer,
        json,
      );
}
