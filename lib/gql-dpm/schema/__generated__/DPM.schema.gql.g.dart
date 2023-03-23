// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DPM.schema.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GTimestamp extends GTimestamp {
  @override
  final String value;

  factory _$GTimestamp([void Function(GTimestampBuilder)? updates]) =>
      (new GTimestampBuilder()..update(updates))._build();

  _$GTimestamp._({required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(value, r'GTimestamp', 'value');
  }

  @override
  GTimestamp rebuild(void Function(GTimestampBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GTimestampBuilder toBuilder() => new GTimestampBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GTimestamp && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GTimestamp')..add('value', value))
        .toString();
  }
}

class GTimestampBuilder implements Builder<GTimestamp, GTimestampBuilder> {
  _$GTimestamp? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  GTimestampBuilder();

  GTimestampBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GTimestamp other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GTimestamp;
  }

  @override
  void update(void Function(GTimestampBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GTimestamp build() => _build();

  _$GTimestamp _build() {
    final _$result = _$v ??
        new _$GTimestamp._(
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'GTimestamp', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
