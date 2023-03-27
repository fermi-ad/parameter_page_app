// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_device_info.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GGetDeviceInfoVars> _$gGetDeviceInfoVarsSerializer =
    new _$GGetDeviceInfoVarsSerializer();

class _$GGetDeviceInfoVarsSerializer
    implements StructuredSerializer<GGetDeviceInfoVars> {
  @override
  final Iterable<Type> types = const [GGetDeviceInfoVars, _$GGetDeviceInfoVars];
  @override
  final String wireName = 'GGetDeviceInfoVars';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, GGetDeviceInfoVars object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'names',
      serializers.serialize(object.names,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  GGetDeviceInfoVars deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GGetDeviceInfoVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'names':
          result.names.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$GGetDeviceInfoVars extends GGetDeviceInfoVars {
  @override
  final BuiltList<String> names;

  factory _$GGetDeviceInfoVars(
          [void Function(GGetDeviceInfoVarsBuilder)? updates]) =>
      (new GGetDeviceInfoVarsBuilder()..update(updates))._build();

  _$GGetDeviceInfoVars._({required this.names}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        names, r'GGetDeviceInfoVars', 'names');
  }

  @override
  GGetDeviceInfoVars rebuild(
          void Function(GGetDeviceInfoVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GGetDeviceInfoVarsBuilder toBuilder() =>
      new GGetDeviceInfoVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GGetDeviceInfoVars && names == other.names;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, names.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GGetDeviceInfoVars')
          ..add('names', names))
        .toString();
  }
}

class GGetDeviceInfoVarsBuilder
    implements Builder<GGetDeviceInfoVars, GGetDeviceInfoVarsBuilder> {
  _$GGetDeviceInfoVars? _$v;

  ListBuilder<String>? _names;
  ListBuilder<String> get names => _$this._names ??= new ListBuilder<String>();
  set names(ListBuilder<String>? names) => _$this._names = names;

  GGetDeviceInfoVarsBuilder();

  GGetDeviceInfoVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _names = $v.names.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GGetDeviceInfoVars other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GGetDeviceInfoVars;
  }

  @override
  void update(void Function(GGetDeviceInfoVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GGetDeviceInfoVars build() => _build();

  _$GGetDeviceInfoVars _build() {
    _$GGetDeviceInfoVars _$result;
    try {
      _$result = _$v ?? new _$GGetDeviceInfoVars._(names: names.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'names';
        names.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GGetDeviceInfoVars', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
