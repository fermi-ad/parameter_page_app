// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_device_info.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetDeviceInfoData> _$gGetDeviceInfoDataSerializer =
    new _$GGetDeviceInfoDataSerializer();
Serializer<GGetDeviceInfoData_acceleratorData>
    _$gGetDeviceInfoDataAcceleratorDataSerializer =
    new _$GGetDeviceInfoData_acceleratorDataSerializer();
Serializer<GGetDeviceInfoData_acceleratorData_data>
    _$gGetDeviceInfoDataAcceleratorDataDataSerializer =
    new _$GGetDeviceInfoData_acceleratorData_dataSerializer();

class _$GGetDeviceInfoDataSerializer
    implements StructuredSerializer<GGetDeviceInfoData> {
  @override
  final Iterable<Type> types = const [GGetDeviceInfoData, _$GGetDeviceInfoData];
  @override
  final String wireName = 'GGetDeviceInfoData';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetDeviceInfoData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'acceleratorData',
      serializers.serialize(object.acceleratorData,
          specifiedType: const FullType(BuiltList,
              const [const FullType(GGetDeviceInfoData_acceleratorData)])),
    ];

    return result;
  }

  @override
  GGetDeviceInfoData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetDeviceInfoDataBuilder();

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
              specifiedType: const FullType(BuiltList, const [
                const FullType(GGetDeviceInfoData_acceleratorData)
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$GGetDeviceInfoData_acceleratorDataSerializer
    implements StructuredSerializer<GGetDeviceInfoData_acceleratorData> {
  @override
  final Iterable<Type> types = const [
    GGetDeviceInfoData_acceleratorData,
    _$GGetDeviceInfoData_acceleratorData
  ];
  @override
  final String wireName = 'GGetDeviceInfoData_acceleratorData';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetDeviceInfoData_acceleratorData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'refId',
      serializers.serialize(object.refId, specifiedType: const FullType(int)),
      'data',
      serializers.serialize(object.data,
          specifiedType:
              const FullType(GGetDeviceInfoData_acceleratorData_data)),
    ];

    return result;
  }

  @override
  GGetDeviceInfoData_acceleratorData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetDeviceInfoData_acceleratorDataBuilder();

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
        case 'data':
          result.data.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(GGetDeviceInfoData_acceleratorData_data))!
              as GGetDeviceInfoData_acceleratorData_data);
          break;
      }
    }

    return result.build();
  }
}

class _$GGetDeviceInfoData_acceleratorData_dataSerializer
    implements StructuredSerializer<GGetDeviceInfoData_acceleratorData_data> {
  @override
  final Iterable<Type> types = const [
    GGetDeviceInfoData_acceleratorData_data,
    _$GGetDeviceInfoData_acceleratorData_data
  ];
  @override
  final String wireName = 'GGetDeviceInfoData_acceleratorData_data';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetDeviceInfoData_acceleratorData_data object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'di',
      serializers.serialize(object.di, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.units;
    if (value != null) {
      result
        ..add('units')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  GGetDeviceInfoData_acceleratorData_data deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetDeviceInfoData_acceleratorData_dataBuilder();

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
        case 'di':
          result.di = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'units':
          result.units = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$GGetDeviceInfoData extends GGetDeviceInfoData {
  @override
  final String G__typename;
  @override
  final BuiltList<GGetDeviceInfoData_acceleratorData> acceleratorData;

  factory _$GGetDeviceInfoData(
          [void Function(GGetDeviceInfoDataBuilder)? updates]) =>
      (new GGetDeviceInfoDataBuilder()..update(updates))._build();

  _$GGetDeviceInfoData._(
      {required this.G__typename, required this.acceleratorData})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetDeviceInfoData', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        acceleratorData, r'GGetDeviceInfoData', 'acceleratorData');
  }

  @override
  GGetDeviceInfoData rebuild(
          void Function(GGetDeviceInfoDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetDeviceInfoDataBuilder toBuilder() =>
      new GGetDeviceInfoDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetDeviceInfoData &&
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
    return (newBuiltValueToStringHelper(r'GGetDeviceInfoData')
          ..add('G__typename', G__typename)
          ..add('acceleratorData', acceleratorData))
        .toString();
  }
}

class GGetDeviceInfoDataBuilder
    implements Builder<GGetDeviceInfoData, GGetDeviceInfoDataBuilder> {
  _$GGetDeviceInfoData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  ListBuilder<GGetDeviceInfoData_acceleratorData>? _acceleratorData;
  ListBuilder<GGetDeviceInfoData_acceleratorData> get acceleratorData =>
      _$this._acceleratorData ??=
          new ListBuilder<GGetDeviceInfoData_acceleratorData>();
  set acceleratorData(
          ListBuilder<GGetDeviceInfoData_acceleratorData>? acceleratorData) =>
      _$this._acceleratorData = acceleratorData;

  GGetDeviceInfoDataBuilder() {
    GGetDeviceInfoData._initializeBuilder(this);
  }

  GGetDeviceInfoDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _acceleratorData = $v.acceleratorData.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetDeviceInfoData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetDeviceInfoData;
  }

  @override
  void update(void Function(GGetDeviceInfoDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetDeviceInfoData build() => _build();

  _$GGetDeviceInfoData _build() {
    _$GGetDeviceInfoData _$result;
    try {
      _$result = _$v ??
          new _$GGetDeviceInfoData._(
              G__typename: BuiltValueNullFieldError.checkNotNull(
                  G__typename, r'GGetDeviceInfoData', 'G__typename'),
              acceleratorData: acceleratorData.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'acceleratorData';
        acceleratorData.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GGetDeviceInfoData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetDeviceInfoData_acceleratorData
    extends GGetDeviceInfoData_acceleratorData {
  @override
  final String G__typename;
  @override
  final int refId;
  @override
  final GGetDeviceInfoData_acceleratorData_data data;

  factory _$GGetDeviceInfoData_acceleratorData(
          [void Function(GGetDeviceInfoData_acceleratorDataBuilder)?
              updates]) =>
      (new GGetDeviceInfoData_acceleratorDataBuilder()..update(updates))
          ._build();

  _$GGetDeviceInfoData_acceleratorData._(
      {required this.G__typename, required this.refId, required this.data})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetDeviceInfoData_acceleratorData', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        refId, r'GGetDeviceInfoData_acceleratorData', 'refId');
    BuiltValueNullFieldError.checkNotNull(
        data, r'GGetDeviceInfoData_acceleratorData', 'data');
  }

  @override
  GGetDeviceInfoData_acceleratorData rebuild(
          void Function(GGetDeviceInfoData_acceleratorDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetDeviceInfoData_acceleratorDataBuilder toBuilder() =>
      new GGetDeviceInfoData_acceleratorDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetDeviceInfoData_acceleratorData &&
        G__typename == other.G__typename &&
        refId == other.refId &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, refId.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetDeviceInfoData_acceleratorData')
          ..add('G__typename', G__typename)
          ..add('refId', refId)
          ..add('data', data))
        .toString();
  }
}

class GGetDeviceInfoData_acceleratorDataBuilder
    implements
        Builder<GGetDeviceInfoData_acceleratorData,
            GGetDeviceInfoData_acceleratorDataBuilder> {
  _$GGetDeviceInfoData_acceleratorData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _refId;
  int? get refId => _$this._refId;
  set refId(int? refId) => _$this._refId = refId;

  GGetDeviceInfoData_acceleratorData_dataBuilder? _data;
  GGetDeviceInfoData_acceleratorData_dataBuilder get data =>
      _$this._data ??= new GGetDeviceInfoData_acceleratorData_dataBuilder();
  set data(GGetDeviceInfoData_acceleratorData_dataBuilder? data) =>
      _$this._data = data;

  GGetDeviceInfoData_acceleratorDataBuilder() {
    GGetDeviceInfoData_acceleratorData._initializeBuilder(this);
  }

  GGetDeviceInfoData_acceleratorDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _refId = $v.refId;
      _data = $v.data.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetDeviceInfoData_acceleratorData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetDeviceInfoData_acceleratorData;
  }

  @override
  void update(
      void Function(GGetDeviceInfoData_acceleratorDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetDeviceInfoData_acceleratorData build() => _build();

  _$GGetDeviceInfoData_acceleratorData _build() {
    _$GGetDeviceInfoData_acceleratorData _$result;
    try {
      _$result = _$v ??
          new _$GGetDeviceInfoData_acceleratorData._(
              G__typename: BuiltValueNullFieldError.checkNotNull(G__typename,
                  r'GGetDeviceInfoData_acceleratorData', 'G__typename'),
              refId: BuiltValueNullFieldError.checkNotNull(
                  refId, r'GGetDeviceInfoData_acceleratorData', 'refId'),
              data: data.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GGetDeviceInfoData_acceleratorData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GGetDeviceInfoData_acceleratorData_data
    extends GGetDeviceInfoData_acceleratorData_data {
  @override
  final String G__typename;
  @override
  final int di;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? units;

  factory _$GGetDeviceInfoData_acceleratorData_data(
          [void Function(GGetDeviceInfoData_acceleratorData_dataBuilder)?
              updates]) =>
      (new GGetDeviceInfoData_acceleratorData_dataBuilder()..update(updates))
          ._build();

  _$GGetDeviceInfoData_acceleratorData_data._(
      {required this.G__typename,
      required this.di,
      required this.name,
      required this.description,
      this.units})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GGetDeviceInfoData_acceleratorData_data', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        di, r'GGetDeviceInfoData_acceleratorData_data', 'di');
    BuiltValueNullFieldError.checkNotNull(
        name, r'GGetDeviceInfoData_acceleratorData_data', 'name');
    BuiltValueNullFieldError.checkNotNull(
        description, r'GGetDeviceInfoData_acceleratorData_data', 'description');
  }

  @override
  GGetDeviceInfoData_acceleratorData_data rebuild(
          void Function(GGetDeviceInfoData_acceleratorData_dataBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetDeviceInfoData_acceleratorData_dataBuilder toBuilder() =>
      new GGetDeviceInfoData_acceleratorData_dataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetDeviceInfoData_acceleratorData_data &&
        G__typename == other.G__typename &&
        di == other.di &&
        name == other.name &&
        description == other.description &&
        units == other.units;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, di.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, units.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'GGetDeviceInfoData_acceleratorData_data')
          ..add('G__typename', G__typename)
          ..add('di', di)
          ..add('name', name)
          ..add('description', description)
          ..add('units', units))
        .toString();
  }
}

class GGetDeviceInfoData_acceleratorData_dataBuilder
    implements
        Builder<GGetDeviceInfoData_acceleratorData_data,
            GGetDeviceInfoData_acceleratorData_dataBuilder> {
  _$GGetDeviceInfoData_acceleratorData_data? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _di;
  int? get di => _$this._di;
  set di(int? di) => _$this._di = di;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _units;
  String? get units => _$this._units;
  set units(String? units) => _$this._units = units;

  GGetDeviceInfoData_acceleratorData_dataBuilder() {
    GGetDeviceInfoData_acceleratorData_data._initializeBuilder(this);
  }

  GGetDeviceInfoData_acceleratorData_dataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _di = $v.di;
      _name = $v.name;
      _description = $v.description;
      _units = $v.units;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetDeviceInfoData_acceleratorData_data other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetDeviceInfoData_acceleratorData_data;
  }

  @override
  void update(
      void Function(GGetDeviceInfoData_acceleratorData_dataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetDeviceInfoData_acceleratorData_data build() => _build();

  _$GGetDeviceInfoData_acceleratorData_data _build() {
    final _$result = _$v ??
        new _$GGetDeviceInfoData_acceleratorData_data._(
            G__typename: BuiltValueNullFieldError.checkNotNull(G__typename,
                r'GGetDeviceInfoData_acceleratorData_data', 'G__typename'),
            di: BuiltValueNullFieldError.checkNotNull(
                di, r'GGetDeviceInfoData_acceleratorData_data', 'di'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GGetDeviceInfoData_acceleratorData_data', 'name'),
            description: BuiltValueNullFieldError.checkNotNull(description,
                r'GGetDeviceInfoData_acceleratorData_data', 'description'),
            units: units);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
