// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gql_exec/gql_exec.dart' as _i4;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.ast.gql.dart'
    as _i5;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.data.gql.dart'
    as _i2;
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.var.gql.dart'
    as _i3;
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i6;

part 'get_device_info.req.gql.g.dart';

abstract class GGetDeviceInfoReq
    implements
        Built<GGetDeviceInfoReq, GGetDeviceInfoReqBuilder>,
        _i1.OperationRequest<_i2.GGetDeviceInfoData, _i3.GGetDeviceInfoVars> {
  GGetDeviceInfoReq._();

  factory GGetDeviceInfoReq([Function(GGetDeviceInfoReqBuilder b) updates]) =
      _$GGetDeviceInfoReq;

  static void _initializeBuilder(GGetDeviceInfoReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'GetDeviceInfo',
    )
    ..executeOnListen = true;
  @override
  _i3.GGetDeviceInfoVars get vars;
  @override
  _i4.Operation get operation;
  @override
  _i4.Request get execRequest => _i4.Request(
        operation: operation,
        variables: vars.toJson(),
      );
  @override
  String? get requestId;
  @override
  @BuiltValueField(serialize: false)
  _i2.GGetDeviceInfoData? Function(
    _i2.GGetDeviceInfoData?,
    _i2.GGetDeviceInfoData?,
  )? get updateResult;
  @override
  _i2.GGetDeviceInfoData? get optimisticResponse;
  @override
  String? get updateCacheHandlerKey;
  @override
  Map<String, dynamic>? get updateCacheHandlerContext;
  @override
  _i1.FetchPolicy? get fetchPolicy;
  @override
  bool get executeOnListen;
  @override
  _i2.GGetDeviceInfoData? parseData(Map<String, dynamic> json) =>
      _i2.GGetDeviceInfoData.fromJson(json);
  static Serializer<GGetDeviceInfoReq> get serializer =>
      _$gGetDeviceInfoReqSerializer;
  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GGetDeviceInfoReq.serializer,
        this,
      ) as Map<String, dynamic>);
  static GGetDeviceInfoReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GGetDeviceInfoReq.serializer,
        json,
      );
}
