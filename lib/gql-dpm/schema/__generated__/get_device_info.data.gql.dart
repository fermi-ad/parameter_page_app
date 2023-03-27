// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i1;

part 'get_device_info.data.gql.g.dart';

abstract class GGetDeviceInfoData
    implements Built<GGetDeviceInfoData, GGetDeviceInfoDataBuilder> {
  GGetDeviceInfoData._();

  factory GGetDeviceInfoData([Function(GGetDeviceInfoDataBuilder b) updates]) =
      _$GGetDeviceInfoData;

  static void _initializeBuilder(GGetDeviceInfoDataBuilder b) =>
      b..G__typename = 'Query';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  BuiltList<GGetDeviceInfoData_acceleratorData> get acceleratorData;
  static Serializer<GGetDeviceInfoData> get serializer =>
      _$gGetDeviceInfoDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_acceleratorData
    implements
        Built<GGetDeviceInfoData_acceleratorData,
            GGetDeviceInfoData_acceleratorDataBuilder> {
  GGetDeviceInfoData_acceleratorData._();

  factory GGetDeviceInfoData_acceleratorData(
          [Function(GGetDeviceInfoData_acceleratorDataBuilder b) updates]) =
      _$GGetDeviceInfoData_acceleratorData;

  static void _initializeBuilder(GGetDeviceInfoData_acceleratorDataBuilder b) =>
      b..G__typename = 'DataReply';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get refId;
  GGetDeviceInfoData_acceleratorData_data get data;
  static Serializer<GGetDeviceInfoData_acceleratorData> get serializer =>
      _$gGetDeviceInfoDataAcceleratorDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_acceleratorData.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_acceleratorData? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_acceleratorData.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_acceleratorData_data
    implements
        Built<GGetDeviceInfoData_acceleratorData_data,
            GGetDeviceInfoData_acceleratorData_dataBuilder> {
  GGetDeviceInfoData_acceleratorData_data._();

  factory GGetDeviceInfoData_acceleratorData_data(
      [Function(GGetDeviceInfoData_acceleratorData_dataBuilder b)
          updates]) = _$GGetDeviceInfoData_acceleratorData_data;

  static void _initializeBuilder(
          GGetDeviceInfoData_acceleratorData_dataBuilder b) =>
      b..G__typename = 'DataInfo';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  int get di;
  String get name;
  String get description;
  String? get units;
  static Serializer<GGetDeviceInfoData_acceleratorData_data> get serializer =>
      _$gGetDeviceInfoDataAcceleratorDataDataSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_acceleratorData_data.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_acceleratorData_data? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_acceleratorData_data.serializer,
        json,
      );
}
