// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_device.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GSetDeviceVars> _$gSetDeviceVarsSerializer =
    new _$GSetDeviceVarsSerializer();

class _$GSetDeviceVarsSerializer
    implements StructuredSerializer<GSetDeviceVars> {
  @override
  final Iterable<Type> types = const [GSetDeviceVars, _$GSetDeviceVars];
  @override
  final String wireName = 'GSetDeviceVars';

  @override
  Iterable<Object?> serialize(Serializers serializers, GSetDeviceVars object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'device',
      serializers.serialize(object.device,
          specifiedType: const FullType(String)),
      'value',
      serializers.serialize(object.value,
          specifiedType: const FullType(_i1.GDevValue)),
    ];

    return result;
  }

  @override
  GSetDeviceVars deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GSetDeviceVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'device':
          result.device = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'value':
          result.value.replace(serializers.deserialize(value,
              specifiedType: const FullType(_i1.GDevValue))! as _i1.GDevValue);
          break;
      }
    }

    return result.build();
  }
}

class _$GSetDeviceVars extends GSetDeviceVars {
  @override
  final String device;
  @override
  final _i1.GDevValue value;

  factory _$GSetDeviceVars([void Function(GSetDeviceVarsBuilder)? updates]) =>
      (new GSetDeviceVarsBuilder()..update(updates))._build();

  _$GSetDeviceVars._({required this.device, required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(device, r'GSetDeviceVars', 'device');
    BuiltValueNullFieldError.checkNotNull(value, r'GSetDeviceVars', 'value');
  }

  @override
  GSetDeviceVars rebuild(void Function(GSetDeviceVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GSetDeviceVarsBuilder toBuilder() =>
      new GSetDeviceVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GSetDeviceVars &&
        device == other.device &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, device.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GSetDeviceVars')
          ..add('device', device)
          ..add('value', value))
        .toString();
  }
}

class GSetDeviceVarsBuilder
    implements Builder<GSetDeviceVars, GSetDeviceVarsBuilder> {
  _$GSetDeviceVars? _$v;

  String? _device;
  String? get device => _$this._device;
  set device(String? device) => _$this._device = device;

  _i1.GDevValueBuilder? _value;
  _i1.GDevValueBuilder get value =>
      _$this._value ??= new _i1.GDevValueBuilder();
  set value(_i1.GDevValueBuilder? value) => _$this._value = value;

  GSetDeviceVarsBuilder();

  GSetDeviceVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _device = $v.device;
      _value = $v.value.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GSetDeviceVars other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GSetDeviceVars;
  }

  @override
  void update(void Function(GSetDeviceVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GSetDeviceVars build() => _build();

  _$GSetDeviceVars _build() {
    _$GSetDeviceVars _$result;
    try {
      _$result = _$v ??
          new _$GSetDeviceVars._(
              device: BuiltValueNullFieldError.checkNotNull(
                  device, r'GSetDeviceVars', 'device'),
              value: value.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        value.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GSetDeviceVars', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
