// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ferry_exec/ferry_exec.dart' as _i1;
import 'package:gql_exec/gql_exec.dart' as _i4;
import 'package:parameter_page/gql-dpm/schema/__generated__/serializers.gql.dart'
    as _i6;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.ast.gql.dart'
    as _i5;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.data.gql.dart'
    as _i2;
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.var.gql.dart'
    as _i3;

part 'stream_data.req.gql.g.dart';

abstract class GStreamDataReq
    implements
        Built<GStreamDataReq, GStreamDataReqBuilder>,
        _i1.OperationRequest<_i2.GStreamDataData, _i3.GStreamDataVars> {
  GStreamDataReq._();

  factory GStreamDataReq([Function(GStreamDataReqBuilder b) updates]) =
      _$GStreamDataReq;

  static void _initializeBuilder(GStreamDataReqBuilder b) => b
    ..operation = _i4.Operation(
      document: _i5.document,
      operationName: 'StreamData',
    )
    ..executeOnListen = true;
  @override
  _i3.GStreamDataVars get vars;
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
  _i2.GStreamDataData? Function(
    _i2.GStreamDataData?,
    _i2.GStreamDataData?,
  )? get updateResult;
  @override
  _i2.GStreamDataData? get optimisticResponse;
  @override
  String? get updateCacheHandlerKey;
  @override
  Map<String, dynamic>? get updateCacheHandlerContext;
  @override
  _i1.FetchPolicy? get fetchPolicy;
  @override
  bool get executeOnListen;
  @override
  _i2.GStreamDataData? parseData(Map<String, dynamic> json) =>
      _i2.GStreamDataData.fromJson(json);
  static Serializer<GStreamDataReq> get serializer =>
      _$gStreamDataReqSerializer;
  Map<String, dynamic> toJson() => (_i6.serializers.serializeWith(
        GStreamDataReq.serializer,
        this,
      ) as Map<String, dynamic>);
  static GStreamDataReq? fromJson(Map<String, dynamic> json) =>
      _i6.serializers.deserializeWith(
        GStreamDataReq.serializer,
        json,
      );
}
