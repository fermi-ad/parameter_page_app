// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:gql_code_builder/src/serializers/inline_fragment_serializer.dart'
    as _i2;
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
  GGetDeviceInfoData_deviceInfo get deviceInfo;
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

abstract class GGetDeviceInfoData_deviceInfo
    implements
        Built<GGetDeviceInfoData_deviceInfo,
            GGetDeviceInfoData_deviceInfoBuilder> {
  GGetDeviceInfoData_deviceInfo._();

  factory GGetDeviceInfoData_deviceInfo(
          [Function(GGetDeviceInfoData_deviceInfoBuilder b) updates]) =
      _$GGetDeviceInfoData_deviceInfo;

  static void _initializeBuilder(GGetDeviceInfoData_deviceInfoBuilder b) =>
      b..G__typename = 'DeviceInfoReply';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  BuiltList<GGetDeviceInfoData_deviceInfo_result> get result;
  static Serializer<GGetDeviceInfoData_deviceInfo> get serializer =>
      _$gGetDeviceInfoDataDeviceInfoSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo? fromJson(Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result {
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  static Serializer<GGetDeviceInfoData_deviceInfo_result> get serializer =>
      _i2.InlineFragmentSerializer<GGetDeviceInfoData_deviceInfo_result>(
        'GGetDeviceInfoData_deviceInfo_result',
        GGetDeviceInfoData_deviceInfo_result__base,
        {
          'DeviceInfo': GGetDeviceInfoData_deviceInfo_result__asDeviceInfo,
          'ErrorReply': GGetDeviceInfoData_deviceInfo_result__asErrorReply,
        },
      );
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result__base
    implements
        Built<GGetDeviceInfoData_deviceInfo_result__base,
            GGetDeviceInfoData_deviceInfo_result__baseBuilder>,
        GGetDeviceInfoData_deviceInfo_result {
  GGetDeviceInfoData_deviceInfo_result__base._();

  factory GGetDeviceInfoData_deviceInfo_result__base(
      [Function(GGetDeviceInfoData_deviceInfo_result__baseBuilder b)
          updates]) = _$GGetDeviceInfoData_deviceInfo_result__base;

  static void _initializeBuilder(
          GGetDeviceInfoData_deviceInfo_result__baseBuilder b) =>
      b..G__typename = 'DeviceInfoResult';
  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  static Serializer<GGetDeviceInfoData_deviceInfo_result__base>
      get serializer => _$gGetDeviceInfoDataDeviceInfoResultBaseSerializer;
  @override
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result__base.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result__base? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result__base.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result__asDeviceInfo
    implements
        Built<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo,
            GGetDeviceInfoData_deviceInfo_result__asDeviceInfoBuilder>,
        GGetDeviceInfoData_deviceInfo_result {
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo._();

  factory GGetDeviceInfoData_deviceInfo_result__asDeviceInfo(
      [Function(GGetDeviceInfoData_deviceInfo_result__asDeviceInfoBuilder b)
          updates]) = _$GGetDeviceInfoData_deviceInfo_result__asDeviceInfo;

  static void _initializeBuilder(
          GGetDeviceInfoData_deviceInfo_result__asDeviceInfoBuilder b) =>
      b..G__typename = 'DeviceInfo';
  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String get description;
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading? get reading;
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting? get setting;
  static Serializer<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo>
      get serializer =>
          _$gGetDeviceInfoDataDeviceInfoResultAsDeviceInfoSerializer;
  @override
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result__asDeviceInfo? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading
    implements
        Built<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading,
            GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_readingBuilder> {
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading._();

  factory GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading(
      [Function(
              GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_readingBuilder
                  b)
          updates]) = _$GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading;

  static void _initializeBuilder(
          GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_readingBuilder
              b) =>
      b..G__typename = 'DeviceProperty';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String? get primaryUnits;
  String? get commonUnits;
  static Serializer<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading>
      get serializer =>
          _$gGetDeviceInfoDataDeviceInfoResultAsDeviceInfoReadingSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting
    implements
        Built<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting,
            GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_settingBuilder> {
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting._();

  factory GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting(
      [Function(
              GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_settingBuilder
                  b)
          updates]) = _$GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting;

  static void _initializeBuilder(
          GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_settingBuilder
              b) =>
      b..G__typename = 'DeviceProperty';
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String? get primaryUnits;
  String? get commonUnits;
  static Serializer<GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting>
      get serializer =>
          _$gGetDeviceInfoDataDeviceInfoResultAsDeviceInfoSettingSerializer;
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting.serializer,
        json,
      );
}

abstract class GGetDeviceInfoData_deviceInfo_result__asErrorReply
    implements
        Built<GGetDeviceInfoData_deviceInfo_result__asErrorReply,
            GGetDeviceInfoData_deviceInfo_result__asErrorReplyBuilder>,
        GGetDeviceInfoData_deviceInfo_result {
  GGetDeviceInfoData_deviceInfo_result__asErrorReply._();

  factory GGetDeviceInfoData_deviceInfo_result__asErrorReply(
      [Function(GGetDeviceInfoData_deviceInfo_result__asErrorReplyBuilder b)
          updates]) = _$GGetDeviceInfoData_deviceInfo_result__asErrorReply;

  static void _initializeBuilder(
          GGetDeviceInfoData_deviceInfo_result__asErrorReplyBuilder b) =>
      b..G__typename = 'ErrorReply';
  @override
  @BuiltValueField(wireName: '__typename')
  String get G__typename;
  String get message;
  static Serializer<GGetDeviceInfoData_deviceInfo_result__asErrorReply>
      get serializer =>
          _$gGetDeviceInfoDataDeviceInfoResultAsErrorReplySerializer;
  @override
  Map<String, dynamic> toJson() => (_i1.serializers.serializeWith(
        GGetDeviceInfoData_deviceInfo_result__asErrorReply.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoData_deviceInfo_result__asErrorReply? fromJson(
          Map<String, dynamic> json) =>
      _i1.serializers.deserializeWith(
        GGetDeviceInfoData_deviceInfo_result__asErrorReply.serializer,
        json,
      );
}
