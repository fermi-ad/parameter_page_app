// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' show StandardJsonPlugin;
import 'package:ferry_exec/ferry_exec.dart';
import 'package:gql_code_builder/src/serializers/operation_serializer.dart'
    show OperationSerializer;
import 'package:parameter_page/gql-dpm/schema/__generated__/DPM.schema.gql.dart'
    show GDevValue;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.data.gql.dart'
    show
        GGetDeviceInfoData_deviceInfo_result,
        GGetDeviceInfoData,
        GGetDeviceInfoData_deviceInfo,
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo,
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading,
        GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting,
        GGetDeviceInfoData_deviceInfo_result__asErrorReply,
        GGetDeviceInfoData_deviceInfo_result__base;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.req.gql.dart'
    show GGetDeviceInfoReq;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.var.gql.dart'
    show GGetDeviceInfoVars;
import 'package:parameter_page/gql-dpm/schema/__generated__/set_device.data.gql.dart'
    show GSetDeviceData, GSetDeviceData_setDevice;
import 'package:parameter_page/gql-dpm/schema/__generated__/set_device.req.gql.dart'
    show GSetDeviceReq;
import 'package:parameter_page/gql-dpm/schema/__generated__/set_device.var.gql.dart'
    show GSetDeviceVars;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.data.gql.dart'
    show
        GStreamDataData_acceleratorData_data_result,
        GStreamDataData,
        GStreamDataData_acceleratorData,
        GStreamDataData_acceleratorData_data,
        GStreamDataData_acceleratorData_data_result__asScalar,
        GStreamDataData_acceleratorData_data_result__asStatusReply,
        GStreamDataData_acceleratorData_data_result__base;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.req.gql.dart'
    show GStreamDataReq;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.var.gql.dart'
    show GStreamDataVars;
import 'package:parameter_page/gql-dpm/schema/date_serializer.dart'
    show DateSerializer;

part 'serializers.gql.g.dart';

final SerializersBuilder _serializersBuilder = _$serializers.toBuilder()
  ..add(OperationSerializer())
  ..add(DateSerializer())
  ..add(GGetDeviceInfoData_deviceInfo_result.serializer)
  ..add(GStreamDataData_acceleratorData_data_result.serializer)
  ..addPlugin(StandardJsonPlugin());
@SerializersFor([
  GDevValue,
  GGetDeviceInfoData,
  GGetDeviceInfoData_deviceInfo,
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo,
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_reading,
  GGetDeviceInfoData_deviceInfo_result__asDeviceInfo_setting,
  GGetDeviceInfoData_deviceInfo_result__asErrorReply,
  GGetDeviceInfoData_deviceInfo_result__base,
  GGetDeviceInfoReq,
  GGetDeviceInfoVars,
  GSetDeviceData,
  GSetDeviceData_setDevice,
  GSetDeviceReq,
  GSetDeviceVars,
  GStreamDataData,
  GStreamDataData_acceleratorData,
  GStreamDataData_acceleratorData_data,
  GStreamDataData_acceleratorData_data_result__asScalar,
  GStreamDataData_acceleratorData_data_result__asStatusReply,
  GStreamDataData_acceleratorData_data_result__base,
  GStreamDataReq,
  GStreamDataVars,
])
final Serializers serializers = _serializersBuilder.build();
