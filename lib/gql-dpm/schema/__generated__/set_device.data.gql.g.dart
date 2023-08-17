// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_device.data.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GSetDeviceData> _$gSetDeviceDataSerializer =
    new _$GSetDeviceDataSerializer();
Serializer<GSetDeviceData_setDevice> _$gSetDeviceDataSetDeviceSerializer =
    new _$GSetDeviceData_setDeviceSerializer();

class _$GSetDeviceDataSerializer
    implements StructuredSerializer<GSetDeviceData> {
  @override
  final Iterable<Type> types = const [GSetDeviceData, _$GSetDeviceData];
  @override
  final String wireName = 'GSetDeviceData';

  @override
  Iterable<Object?> serialize(Serializers serializers, GSetDeviceData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      '__typename',
      serializers.serialize(object.G__typename,
          specifiedType: const FullType(String)),
      'setDevice',
      serializers.serialize(object.setDevice,
          specifiedType: const FullType(GSetDeviceData_setDevice)),
    ];

    return result;
  }

  @override
  GSetDeviceData deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GSetDeviceDataBuilder();

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
        case 'setDevice':
          result.setDevice.replace(serializers.deserialize(value,
                  specifiedType: const FullType(GSetDeviceData_setDevice))!
              as GSetDeviceData_setDevice);
          break;
      }
    }

    return result.build();
  }
}

class _$GSetDeviceData_setDeviceSerializer
    implements StructuredSerializer<GSetDeviceData_setDevice> {
  @override
  final Iterable<Type> types = const [
    GSetDeviceData_setDevice,
    _$GSetDeviceData_setDevice
  ];
  @override
  final String wireName = 'GSetDeviceData_setDevice';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GSetDeviceData_setDevice object,
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
  GSetDeviceData_setDevice deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GSetDeviceData_setDeviceBuilder();

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

class _$GSetDeviceData extends GSetDeviceData {
  @override
  final String G__typename;
  @override
  final GSetDeviceData_setDevice setDevice;

  factory _$GSetDeviceData([void Function(GSetDeviceDataBuilder)? updates]) =>
      (new GSetDeviceDataBuilder()..update(updates))._build();

  _$GSetDeviceData._({required this.G__typename, required this.setDevice})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GSetDeviceData', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        setDevice, r'GSetDeviceData', 'setDevice');
  }

  @override
  GSetDeviceData rebuild(void Function(GSetDeviceDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GSetDeviceDataBuilder toBuilder() =>
      new GSetDeviceDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GSetDeviceData &&
        G__typename == other.G__typename &&
        setDevice == other.setDevice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, G__typename.hashCode);
    _$hash = $jc(_$hash, setDevice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GSetDeviceData')
          ..add('G__typename', G__typename)
          ..add('setDevice', setDevice))
        .toString();
  }
}

class GSetDeviceDataBuilder
    implements Builder<GSetDeviceData, GSetDeviceDataBuilder> {
  _$GSetDeviceData? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  GSetDeviceData_setDeviceBuilder? _setDevice;
  GSetDeviceData_setDeviceBuilder get setDevice =>
      _$this._setDevice ??= new GSetDeviceData_setDeviceBuilder();
  set setDevice(GSetDeviceData_setDeviceBuilder? setDevice) =>
      _$this._setDevice = setDevice;

  GSetDeviceDataBuilder() {
    GSetDeviceData._initializeBuilder(this);
  }

  GSetDeviceDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _setDevice = $v.setDevice.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GSetDeviceData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GSetDeviceData;
  }

  @override
  void update(void Function(GSetDeviceDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GSetDeviceData build() => _build();

  _$GSetDeviceData _build() {
    _$GSetDeviceData _$result;
    try {
      _$result = _$v ??
          new _$GSetDeviceData._(
              G__typename: BuiltValueNullFieldError.checkNotNull(
                  G__typename, r'GSetDeviceData', 'G__typename'),
              setDevice: setDevice.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'setDevice';
        setDevice.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GSetDeviceData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GSetDeviceData_setDevice extends GSetDeviceData_setDevice {
  @override
  final String G__typename;
  @override
  final int status;

  factory _$GSetDeviceData_setDevice(
          [void Function(GSetDeviceData_setDeviceBuilder)? updates]) =>
      (new GSetDeviceData_setDeviceBuilder()..update(updates))._build();

  _$GSetDeviceData_setDevice._(
      {required this.G__typename, required this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        G__typename, r'GSetDeviceData_setDevice', 'G__typename');
    BuiltValueNullFieldError.checkNotNull(
        status, r'GSetDeviceData_setDevice', 'status');
  }

  @override
  GSetDeviceData_setDevice rebuild(
          void Function(GSetDeviceData_setDeviceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GSetDeviceData_setDeviceBuilder toBuilder() =>
      new GSetDeviceData_setDeviceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GSetDeviceData_setDevice &&
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
    return (newBuiltValueToStringHelper(r'GSetDeviceData_setDevice')
          ..add('G__typename', G__typename)
          ..add('status', status))
        .toString();
  }
}

class GSetDeviceData_setDeviceBuilder
    implements
        Builder<GSetDeviceData_setDevice, GSetDeviceData_setDeviceBuilder> {
  _$GSetDeviceData_setDevice? _$v;

  String? _G__typename;
  String? get G__typename => _$this._G__typename;
  set G__typename(String? G__typename) => _$this._G__typename = G__typename;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  GSetDeviceData_setDeviceBuilder() {
    GSetDeviceData_setDevice._initializeBuilder(this);
  }

  GSetDeviceData_setDeviceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _G__typename = $v.G__typename;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GSetDeviceData_setDevice other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GSetDeviceData_setDevice;
  }

  @override
  void update(void Function(GSetDeviceData_setDeviceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GSetDeviceData_setDevice build() => _build();

  _$GSetDeviceData_setDevice _build() {
    final _$result = _$v ??
        new _$GSetDeviceData_setDevice._(
            G__typename: BuiltValueNullFieldError.checkNotNull(
                G__typename, r'GSetDeviceData_setDevice', 'G__typename'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'GSetDeviceData_setDevice', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
