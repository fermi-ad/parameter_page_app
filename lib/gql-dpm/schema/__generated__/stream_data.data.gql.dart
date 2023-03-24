// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gql_code_builder/src/serializers/inline_fragment_serializer.dart'
    as _i3;
import 'package:parameter_page/gql-dpm/schema/__generated__/DPM.schema.gql.dart'
    as _i2;
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i1;

part 'stream_data.data.gql.g.dart';

abstract class GStreamDataData
    implements Built<GStreamDataData, GStreamDataDataBuilder> {
  GStreamDataData._();

  factory GStreamDataData([Function(GStreamDataDataBuilder b) updates]) =
      _$GStreamDataData;

  static void _initializeBuilder(GStreamDataDataBuilder b) =>
      b..G__typename = 'Subscription';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  GStreamDataData_acceleratorData get acceleratorData;
  static Serializer<GStreamDataData> get serializer =>
      _$gStreamDataDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData.serializer,
        json,
      );
}

abstract class GStreamDataData_acceleratorData
    implements
        Built<GStreamDataData_acceleratorData,
            GStreamDataData_acceleratorDataBuilder> {
  GStreamDataData_acceleratorData._();

  factory GStreamDataData_acceleratorData(
          [Function(GStreamDataData_acceleratorDataBuilder b) updates]) =
      _$GStreamDataData_acceleratorData;

  static void _initializeBuilder(GStreamDataData_acceleratorDataBuilder b) =>
      b..G__typename = 'DataReply';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get refId;
  _i2.GTimestamp get cycle;
  GStreamDataData_acceleratorData_data get data;
  static Serializer<GStreamDataData_acceleratorData> get serializer =>
      _$gStreamDataDataAcceleratorDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData_acceleratorData.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData_acceleratorData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData_acceleratorData.serializer,
        json,
      );
}

abstract class GStreamDataData_acceleratorData_data
    implements
        Built<GStreamDataData_acceleratorData_data,
            GStreamDataData_acceleratorData_dataBuilder> {
  GStreamDataData_acceleratorData_data._();

  factory GStreamDataData_acceleratorData_data(
          [Function(GStreamDataData_acceleratorData_dataBuilder b) updates]) =
      _$GStreamDataData_acceleratorData_data;

  static void _initializeBuilder(
          GStreamDataData_acceleratorData_dataBuilder b) =>
      b..G__typename = 'DataInfo';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  _i2.GTimestamp get timestamp;
  GStreamDataData_acceleratorData_data_result get result;
  static Serializer<GStreamDataData_acceleratorData_data> get serializer =>
      _$gStreamDataDataAcceleratorDataDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData_acceleratorData_data.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData_acceleratorData_data? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData_acceleratorData_data.serializer,
        json,
      );
}

abstract class GStreamDataData_acceleratorData_data_result {
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  static Serializer<GStreamDataData_acceleratorData_data_result>
      get serializer => _i3.InlineFragmentSerializer<
              GStreamDataData_acceleratorData_data_result>(
            'GStreamDataData_acceleratorData_data_result',
            GStreamDataData_acceleratorData_data_result__base,
            {'Scalar': GStreamDataData_acceleratorData_data_result__asScalar},
          );
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData_acceleratorData_data_result.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData_acceleratorData_data_result? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData_acceleratorData_data_result.serializer,
        json,
      );
}

abstract class GStreamDataData_acceleratorData_data_result__base
    implements
        Built<GStreamDataData_acceleratorData_data_result__base,
            GStreamDataData_acceleratorData_data_result__baseBuilder>,
        GStreamDataData_acceleratorData_data_result {
  GStreamDataData_acceleratorData_data_result__base._();

  factory GStreamDataData_acceleratorData_data_result__base(
      [Function(GStreamDataData_acceleratorData_data_result__baseBuilder b)
          updates]) = _$GStreamDataData_acceleratorData_data_result__base;

  static void _initializeBuilder(
          GStreamDataData_acceleratorData_data_result__baseBuilder b) =>
      b..G__typename = 'DataType';
  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  static Serializer<GStreamDataData_acceleratorData_data_result__base>
      get serializer =>
          _$gStreamDataDataAcceleratorDataDataResultBaseSerializer;
  @override
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData_acceleratorData_data_result__base.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData_acceleratorData_data_result__base? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData_acceleratorData_data_result__base.serializer,
        json,
      );
}

abstract class GStreamDataData_acceleratorData_data_result__asScalar
    implements
        Built<GStreamDataData_acceleratorData_data_result__asScalar,
            GStreamDataData_acceleratorData_data_result__asScalarBuilder>,
        GStreamDataData_acceleratorData_data_result {
  GStreamDataData_acceleratorData_data_result__asScalar._();

  factory GStreamDataData_acceleratorData_data_result__asScalar(
      [Function(GStreamDataData_acceleratorData_data_result__asScalarBuilder b)
          updates]) = _$GStreamDataData_acceleratorData_data_result__asScalar;

  static void _initializeBuilder(
          GStreamDataData_acceleratorData_data_result__asScalarBuilder b) =>
      b..G__typename = 'Scalar';
  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  double? get value;
  static Serializer<GStreamDataData_acceleratorData_data_result__asScalar>
      get serializer =>
          _$gStreamDataDataAcceleratorDataDataResultAsScalarSerializer;
  @override
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GStreamDataData_acceleratorData_data_result__asScalar.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataData_acceleratorData_data_result__asScalar? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GStreamDataData_acceleratorData_data_result__asScalar.serializer,
        json,
      );
}
