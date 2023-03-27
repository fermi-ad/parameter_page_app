// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_data.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GStreamDataData> _$gStreamDataDataSerializer =
    new _$GStreamDataDataSerializer();
Serializer<GStreamDataData_acceleratorData>
    _$gStreamDataDataAcceleratorDataSerializer =
    new _$GStreamDataData_acceleratorDataSerializer();
Serializer<GStreamDataData_acceleratorData_data>
    _$gStreamDataDataAcceleratorDataDataSerializer =
    new _$GStreamDataData_acceleratorData_dataSerializer();
Serializer<GStreamDataData_acceleratorData_data_result__base>
    _$gStreamDataDataAcceleratorDataDataResultBaseSerializer =
    new _$GStreamDataData_acceleratorData_data_result__baseSerializer();
Serializer<GStreamDataData_acceleratorData_data_result__asStatusReply>
    _$gStreamDataDataAcceleratorDataDataResultAsStatusReplySerializer =
    new _$GStreamDataData_acceleratorData_data_result__asStatusReplySerializer();
Serializer<GStreamDataData_acceleratorData_data_result__asScalar>
    _$gStreamDataDataAcceleratorDataDataResultAsScalarSerializer =
    new _$GStreamDataData_acceleratorData_data_result__asScalarSerializer();

class _$GStreamDataDataSerializer
    implements StructuredSerializer<GStreamDataData> {
  @override
  final Iterable<Type> types = const [GStreamDataData, _$GStreamDataData];
  @override
  final String wireName = 'GStreamDataData';

  @override
  Iterable<Object?> serialize(Serializers serializers, GStreamDataData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'acceleratorData',
      serializers.serialize(object.acceleratorData,
          specifiedType: const FullType(GStreamDataData_acceleratorData)),
    ];

    return result;
  }

  @override
  GStreamDataData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GStreamDataDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'acceleratorData':
          result.acceleratorData.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(GStreamDataData_acceleratorData))!
              as GStreamDataData_acceleratorData);
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData_acceleratorDataSerializer
    implements StructuredSerializer<GStreamDataData_acceleratorData> {
  @override
  final Iterable<Type> types = const [
    GStreamDataData_acceleratorData,
    _$GStreamDataData_acceleratorData
  ];
  @override
  final String wireName = 'GStreamDataData_acceleratorData';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GStreamDataData_acceleratorData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'refId',
      serializers.serialize(object.refId, specifiedType: const FullType(int)),
      'cycle',
      serializers.serialize(object.cycle, specifiedType: const FullType(int)),
      'data',
      serializers.serialize(object.data,
          specifiedType: const FullType(GStreamDataData_acceleratorData_data)),
    ];

    return result;
  }

  @override
  GStreamDataData_acceleratorData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GStreamDataData_acceleratorDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'refId':
          result.refId = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'cycle':
          result.cycle = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(GStreamDataData_acceleratorData_data))!
              as GStreamDataData_acceleratorData_data);
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData_acceleratorData_dataSerializer
    implements StructuredSerializer<GStreamDataData_acceleratorData_data> {
  @override
  final Iterable<Type> types = const [
    GStreamDataData_acceleratorData_data,
    _$GStreamDataData_acceleratorData_data
  ];
  @override
  final String wireName = 'GStreamDataData_acceleratorData_data';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GStreamDataData_acceleratorData_data object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'timestamp',
      serializers.serialize(object.timestamp,
          specifiedType: const FullType(DateTime)),
      'result',
      serializers.serialize(object.result,
          specifiedType:
              const FullType(GStreamDataData_acceleratorData_data_result)),
    ];

    return result;
  }

  @override
  GStreamDataData_acceleratorData_data deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GStreamDataData_acceleratorData_dataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'timestamp':
          result.timestamp = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'result':
          result.result = serializers.deserialize(value,
                  specifiedType: const FullType(
                      GStreamDataData_acceleratorData_data_result))!
              as GStreamDataData_acceleratorData_data_result;
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData_acceleratorData_data_result__baseSerializer
    implements
        StructuredSerializer<
            GStreamDataData_acceleratorData_data_result__base> {
  @override
  final Iterable<Type> types = const [
    GStreamDataData_acceleratorData_data_result__base,
    _$GStreamDataData_acceleratorData_data_result__base
  ];
  @override
  final String wireName = 'GStreamDataData_acceleratorData_data_result__base';

  @override
  Iterable<Object?> serialize(Serializers serializers,
      GStreamDataData_acceleratorData_data_result__base object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  GStreamDataData_acceleratorData_data_result__base deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result =
        new GStreamDataData_acceleratorData_data_result__baseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData_acceleratorData_data_result__asStatusReplySerializer
    implements
        StructuredSerializer<
            GStreamDataData_acceleratorData_data_result__asStatusReply> {
  @override
  final Iterable<Type> types = const [
    GStreamDataData_acceleratorData_data_result__asStatusReply,
    _$GStreamDataData_acceleratorData_data_result__asStatusReply
  ];
  @override
  final String wireName =
      'GStreamDataData_acceleratorData_data_result__asStatusReply';

  @override
  Iterable<Object?> serialize(Serializers serializers,
      GStreamDataData_acceleratorData_data_result__asStatusReply object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  GStreamDataData_acceleratorData_data_result__asStatusReply deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result =
        new GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData_acceleratorData_data_result__asScalarSerializer
    implements
        StructuredSerializer<
            GStreamDataData_acceleratorData_data_result__asScalar> {
  @override
  final Iterable<Type> types = const [
    GStreamDataData_acceleratorData_data_result__asScalar,
    _$GStreamDataData_acceleratorData_data_result__asScalar
  ];
  @override
  final String wireName =
      'GStreamDataData_acceleratorData_data_result__asScalar';

  @override
  Iterable<Object?> serialize(Serializers serializers,
      GStreamDataData_acceleratorData_data_result__asScalar object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.scalarValue;
    if (value != null) {
      result
        ..add('scalarValue')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  GStreamDataData_acceleratorData_data_result__asScalar deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result =
        new GStreamDataData_acceleratorData_data_result__asScalarBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '__typename':
          result.G__typename = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'scalarValue':
          result.scalarValue = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataData extends GStreamDataData {
  @override
  final String G__typename;
  @override
  final GStreamDataData_acceleratorData acceleratorData;

  factory _$GStreamDataData([void Function(GStreamDataDataBuilder)? updates]) =>
      (new GStreamDataDataBuilder()..update(updates))._build();

  _$GStreamDataData._(
      {required this.G__typename, required this.acceleratorData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GStreamDataData', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        acceleratorData, r'GStreamDataData', 'acceleratorData');
  }

  @override
  GStreamDataData rebuild(void Function(GStreamDataDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataDataBuilder toBuilder() =>
      new GStreamDataDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataData &&
        G__typename == other.G__typename &&
        acceleratorData == other.acceleratorData;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, acceleratorData.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GStreamDataData')
          ..add('G__typename', G__typename)
          ..add('acceleratorData', acceleratorData))
        .toString();
  }
}

class GStreamDataDataBuilder
    implements Builder<GStreamDataData, GStreamDataDataBuilder> {
  _$GStreamDataData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GStreamDataData_acceleratorDataBuilder? _acceleratorData;
  GStreamDataData_acceleratorDataBuilder get acceleratorData =>
      _$this._acceleratorData ??= new GStreamDataData_acceleratorDataBuilder();
  set acceleratorData(
          GStreamDataData_acceleratorDataBuilder? acceleratorData) =>
      _$this._acceleratorData = acceleratorData;

  GStreamDataDataBuilder() {
    GStreamDataData._initializeBuilder(this);
  }

  GStreamDataDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _acceleratorData = $v.acceleratorData.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData;
  }

  @override
  void update(void Function(GStreamDataDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData build() => _build();

  _$GStreamDataData _build() {
    _$GStreamDataData _$result;
    try {
      _$result = _$v ??
          new _$GStreamDataData._(
              G__typename: BuiltValueNullFieldError.checkNotNull(
                  G__typename, r'GStreamDataData', 'G__typename'),
              acceleratorData: acceleratorData.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceleratorData';
        acceleratorData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GStreamDataData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GStreamDataData_acceleratorData
    extends GStreamDataData_acceleratorData {
  @override
  final String G__typename;
  @override
  final int refId;
  @override
  final int cycle;
  @override
  final GStreamDataData_acceleratorData_data data;

  factory _$GStreamDataData_acceleratorData(
          [void Function(GStreamDataData_acceleratorDataBuilder)? updates]) =>
      (new GStreamDataData_acceleratorDataBuilder()..update(updates))._build();

  _$GStreamDataData_acceleratorData._(
      {required this.G__typename,
      required this.refId,
      required this.cycle,
      required this.data})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GStreamDataData_acceleratorData', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        refId, r'GStreamDataData_acceleratorData', 'refId');
    BuiltValueNullFieldError.checkNotNull(
        cycle, r'GStreamDataData_acceleratorData', 'cycle');
    BuiltValueNullFieldError.checkNotNull(
        data, r'GStreamDataData_acceleratorData', 'data');
  }

  @override
  GStreamDataData_acceleratorData rebuild(
          void Function(GStreamDataData_acceleratorDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataData_acceleratorDataBuilder toBuilder() =>
      new GStreamDataData_acceleratorDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataData_acceleratorData &&
        G__typename == other.G__typename &&
        refId == other.refId &&
        cycle == other.cycle &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, refId.hashCode);
    _$hash = $jc(_$hash, cycle.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GStreamDataData_acceleratorData')
          ..add('G__typename', G__typename)
          ..add('refId', refId)
          ..add('cycle', cycle)
          ..add('data', data))
        .toString();
  }
}

class GStreamDataData_acceleratorDataBuilder
    implements
        Builder<GStreamDataData_acceleratorData,
            GStreamDataData_acceleratorDataBuilder> {
  _$GStreamDataData_acceleratorData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _refId;
  int? get refId => _$this._refId;
  set refId(int? refId) => _$this._refId = refId;

  int? _cycle;
  int? get cycle => _$this._cycle;
  set cycle(int? cycle) => _$this._cycle = cycle;

  GStreamDataData_acceleratorData_dataBuilder? _data;
  GStreamDataData_acceleratorData_dataBuilder get data =>
      _$this._data ??= new GStreamDataData_acceleratorData_dataBuilder();
  set data(GStreamDataData_acceleratorData_dataBuilder? data) =>
      _$this._data = data;

  GStreamDataData_acceleratorDataBuilder() {
    GStreamDataData_acceleratorData._initializeBuilder(this);
  }

  GStreamDataData_acceleratorDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _refId = $v.refId;
      _cycle = $v.cycle;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataData_acceleratorData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData_acceleratorData;
  }

  @override
  void update(void Function(GStreamDataData_acceleratorDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData_acceleratorData build() => _build();

  _$GStreamDataData_acceleratorData _build() {
    _$GStreamDataData_acceleratorData _$result;
    try {
      _$result = _$v ??
          new _$GStreamDataData_acceleratorData._(
              G__typename: BuiltValueNullFieldError.checkNotNull(G__typename,
                  r'GStreamDataData_acceleratorData', 'G__typename'),
              refId: BuiltValueNullFieldError.checkNotNull(
                  refId, r'GStreamDataData_acceleratorData', 'refId'),
              cycle: BuiltValueNullFieldError.checkNotNull(
                  cycle, r'GStreamDataData_acceleratorData', 'cycle'),
              data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GStreamDataData_acceleratorData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GStreamDataData_acceleratorData_data
    extends GStreamDataData_acceleratorData_data {
  @override
  final String G__typename;
  @override
  final DateTime timestamp;
  @override
  final GStreamDataData_acceleratorData_data_result result;

  factory _$GStreamDataData_acceleratorData_data(
          [void Function(GStreamDataData_acceleratorData_dataBuilder)?
              updates]) =>
      (new GStreamDataData_acceleratorData_dataBuilder()..update(updates))
          ._build();

  _$GStreamDataData_acceleratorData_data._(
      {required this.G__typename,
      required this.timestamp,
      required this.result})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GStreamDataData_acceleratorData_data', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        timestamp, r'GStreamDataData_acceleratorData_data', 'timestamp');
    BuiltValueNullFieldError.checkNotNull(
        result, r'GStreamDataData_acceleratorData_data', 'result');
  }

  @override
  GStreamDataData_acceleratorData_data rebuild(
          void Function(GStreamDataData_acceleratorData_dataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataData_acceleratorData_dataBuilder toBuilder() =>
      new GStreamDataData_acceleratorData_dataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataData_acceleratorData_data &&
        G__typename == other.G__typename &&
        timestamp == other.timestamp &&
        result == other.result;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GStreamDataData_acceleratorData_data')
          ..add('G__typename', G__typename)
          ..add('timestamp', timestamp)
          ..add('result', result))
        .toString();
  }
}

class GStreamDataData_acceleratorData_dataBuilder
    implements
        Builder<GStreamDataData_acceleratorData_data,
            GStreamDataData_acceleratorData_dataBuilder> {
  _$GStreamDataData_acceleratorData_data? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  GStreamDataData_acceleratorData_data_result? _result;
  GStreamDataData_acceleratorData_data_result? get result => _$this._result;
  set result(GStreamDataData_acceleratorData_data_result? result) =>
      _$this._result = result;

  GStreamDataData_acceleratorData_dataBuilder() {
    GStreamDataData_acceleratorData_data._initializeBuilder(this);
  }

  GStreamDataData_acceleratorData_dataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _timestamp = $v.timestamp;
      _result = $v.result;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataData_acceleratorData_data other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData_acceleratorData_data;
  }

  @override
  void update(
      void Function(GStreamDataData_acceleratorData_dataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData_acceleratorData_data build() => _build();

  _$GStreamDataData_acceleratorData_data _build() {
    final _$result = _$v ??
        new _$GStreamDataData_acceleratorData_data._(
            G__typename: BuiltValueNullFieldError.checkNotNull(G__typename,
                r'GStreamDataData_acceleratorData_data', 'G__typename'),
            timestamp: BuiltValueNullFieldError.checkNotNull(timestamp,
                r'GStreamDataData_acceleratorData_data', 'timestamp'),
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'GStreamDataData_acceleratorData_data', 'result'));
    replace(_$result);
    return _$result;
  }
}

class _$GStreamDataData_acceleratorData_data_result__base
    extends GStreamDataData_acceleratorData_data_result__base {
  @override
  final String G__typename;

  factory _$GStreamDataData_acceleratorData_data_result__base(
          [void Function(
                  GStreamDataData_acceleratorData_data_result__baseBuilder)?
              updates]) =>
      (new GStreamDataData_acceleratorData_data_result__baseBuilder()
            ..update(updates))
          ._build();

  _$GStreamDataData_acceleratorData_data_result__base._(
      {required this.G__typename})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(G__typename,
        r'GStreamDataData_acceleratorData_data_result__base', 'G__typename');
  }

  @override
  GStreamDataData_acceleratorData_data_result__base rebuild(
          void Function(
                  GStreamDataData_acceleratorData_data_result__baseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataData_acceleratorData_data_result__baseBuilder toBuilder() =>
      new GStreamDataData_acceleratorData_data_result__baseBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataData_acceleratorData_data_result__base &&
        G__typename == other.G__typename;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GStreamDataData_acceleratorData_data_result__base')
          ..add('G__typename', G__typename))
        .toString();
  }
}

class GStreamDataData_acceleratorData_data_result__baseBuilder
    implements
        Builder<GStreamDataData_acceleratorData_data_result__base,
            GStreamDataData_acceleratorData_data_result__baseBuilder> {
  _$GStreamDataData_acceleratorData_data_result__base? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GStreamDataData_acceleratorData_data_result__baseBuilder() {
    GStreamDataData_acceleratorData_data_result__base._initializeBuilder(this);
  }

  GStreamDataData_acceleratorData_data_result__baseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataData_acceleratorData_data_result__base other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData_acceleratorData_data_result__base;
  }

  @override
  void update(
      void Function(GStreamDataData_acceleratorData_data_result__baseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData_acceleratorData_data_result__base build() => _build();

  _$GStreamDataData_acceleratorData_data_result__base _build() {
    final _$result = _$v ??
        new _$GStreamDataData_acceleratorData_data_result__base._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename,
                r'GStreamDataData_acceleratorData_data_result__base',
                'G__typename'));
    replace(_$result);
    return _$result;
  }
}

class _$GStreamDataData_acceleratorData_data_result__asStatusReply
    extends GStreamDataData_acceleratorData_data_result__asStatusReply {
  @override
  final String G__typename;
  @override
  final int status;

  factory _$GStreamDataData_acceleratorData_data_result__asStatusReply(
          [void Function(
                  GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder)?
              updates]) =>
      (new GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder()
            ..update(updates))
          ._build();

  _$GStreamDataData_acceleratorData_data_result__asStatusReply._(
      {required this.G__typename, required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename,
        r'GStreamDataData_acceleratorData_data_result__asStatusReply',
        'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        status,
        r'GStreamDataData_acceleratorData_data_result__asStatusReply',
        'status');
  }

  @override
  GStreamDataData_acceleratorData_data_result__asStatusReply rebuild(
          void Function(
                  GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder
      toBuilder() =>
          new GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder()
            ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is GStreamDataData_acceleratorData_data_result__asStatusReply &&
        G__typename == other.G__typename &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GStreamDataData_acceleratorData_data_result__asStatusReply')
          ..add('G__typename', G__typename)
          ..add('status', status))
        .toString();
  }
}

class GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder
    implements
        Builder<GStreamDataData_acceleratorData_data_result__asStatusReply,
            GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder> {
  _$GStreamDataData_acceleratorData_data_result__asStatusReply? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder() {
    GStreamDataData_acceleratorData_data_result__asStatusReply
        ._initializeBuilder(this);
  }

  GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
      GStreamDataData_acceleratorData_data_result__asStatusReply other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData_acceleratorData_data_result__asStatusReply;
  }

  @override
  void update(
      void Function(
              GStreamDataData_acceleratorData_data_result__asStatusReplyBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData_acceleratorData_data_result__asStatusReply build() =>
      _build();

  _$GStreamDataData_acceleratorData_data_result__asStatusReply _build() {
    final _$result = _$v ??
        new _$GStreamDataData_acceleratorData_data_result__asStatusReply._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename,
                r'GStreamDataData_acceleratorData_data_result__asStatusReply',
                'G__typename'),
            status: BuiltValueNullFieldError.checkNotNull(
                status,
                r'GStreamDataData_acceleratorData_data_result__asStatusReply',
                'status'));
    replace(_$result);
    return _$result;
  }
}

class _$GStreamDataData_acceleratorData_data_result__asScalar
    extends GStreamDataData_acceleratorData_data_result__asScalar {
  @override
  final String G__typename;
  @override
  final double? scalarValue;

  factory _$GStreamDataData_acceleratorData_data_result__asScalar(
          [void Function(
                  GStreamDataData_acceleratorData_data_result__asScalarBuilder)?
              updates]) =>
      (new GStreamDataData_acceleratorData_data_result__asScalarBuilder()
            ..update(updates))
          ._build();

  _$GStreamDataData_acceleratorData_data_result__asScalar._(
      {required this.G__typename, this.scalarValue})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename,
        r'GStreamDataData_acceleratorData_data_result__asScalar',
        'G__typename');
  }

  @override
  GStreamDataData_acceleratorData_data_result__asScalar rebuild(
          void Function(
                  GStreamDataData_acceleratorData_data_result__asScalarBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataData_acceleratorData_data_result__asScalarBuilder toBuilder() =>
      new GStreamDataData_acceleratorData_data_result__asScalarBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataData_acceleratorData_data_result__asScalar &&
        G__typename == other.G__typename &&
        scalarValue == other.scalarValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, scalarValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GStreamDataData_acceleratorData_data_result__asScalar')
          ..add('G__typename', G__typename)
          ..add('scalarValue', scalarValue))
        .toString();
  }
}

class GStreamDataData_acceleratorData_data_result__asScalarBuilder
    implements
        Builder<GStreamDataData_acceleratorData_data_result__asScalar,
            GStreamDataData_acceleratorData_data_result__asScalarBuilder> {
  _$GStreamDataData_acceleratorData_data_result__asScalar? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  double? _scalarValue;
  double? get scalarValue => _$this._scalarValue;
  set scalarValue(double? scalarValue) => _$this._scalarValue = scalarValue;

  GStreamDataData_acceleratorData_data_result__asScalarBuilder() {
    GStreamDataData_acceleratorData_data_result__asScalar._initializeBuilder(
        this);
  }

  GStreamDataData_acceleratorData_data_result__asScalarBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _scalarValue = $v.scalarValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataData_acceleratorData_data_result__asScalar other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataData_acceleratorData_data_result__asScalar;
  }

  @override
  void update(
      void Function(
              GStreamDataData_acceleratorData_data_result__asScalarBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataData_acceleratorData_data_result__asScalar build() => _build();

  _$GStreamDataData_acceleratorData_data_result__asScalar _build() {
    final _$result = _$v ??
        new _$GStreamDataData_acceleratorData_data_result__asScalar._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename,
                r'GStreamDataData_acceleratorData_data_result__asScalar',
                'G__typename'),
            scalarValue: scalarValue);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
