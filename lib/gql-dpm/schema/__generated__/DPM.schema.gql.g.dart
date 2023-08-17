// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DPM.schema.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GDevValue> _$gDevValueSerializer = new _$GDevValueSerializer();

class _$GDevValueSerializer implements StructuredSerializer<GDevValue> {
  @override
  final Iterable<Type> types = const [GDevValue, _$GDevValue];
  @override
  final String wireName = 'GDevValue';

  @override
  Iterable<Object?> serialize(Serializers serializers, GDevValue object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.intVal;
    if (value != null) {
      result
        ..add('intVal')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.scalarVal;
    if (value != null) {
      result
        ..add('scalarVal')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.scalarArrayVal;
    if (value != null) {
      result
        ..add('scalarArrayVal')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(double)])));
    }
    value = object.rawVal;
    if (value != null) {
      result
        ..add('rawVal')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(int)])));
    }
    value = object.textVal;
    if (value != null) {
      result
        ..add('textVal')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.textArrayVal;
    if (value != null) {
      result
        ..add('textArrayVal')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    return result;
  }

  @override
  GDevValue deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GDevValueBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'intVal':
          result.intVal = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'scalarVal':
          result.scalarVal = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'scalarArrayVal':
          result.scalarArrayVal.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(double)]))!
              as BuiltList<Object?>);
          break;
        case 'rawVal':
          result.rawVal.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(int)]))!
              as BuiltList<Object?>);
          break;
        case 'textVal':
          result.textVal = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'textArrayVal':
          result.textArrayVal.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$GDevValue extends GDevValue {
  @override
  final int? intVal;
  @override
  final double? scalarVal;
  @override
  final BuiltList<double>? scalarArrayVal;
  @override
  final BuiltList<int>? rawVal;
  @override
  final String? textVal;
  @override
  final BuiltList<String>? textArrayVal;

  factory _$GDevValue([void Function(GDevValueBuilder)? updates]) =>
      (new GDevValueBuilder()..update(updates))._build();

  _$GDevValue._(
      {this.intVal,
      this.scalarVal,
      this.scalarArrayVal,
      this.rawVal,
      this.textVal,
      this.textArrayVal})
      : super._();

  @override
  GDevValue rebuild(void Function(GDevValueBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GDevValueBuilder toBuilder() => new GDevValueBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GDevValue &&
        intVal == other.intVal &&
        scalarVal == other.scalarVal &&
        scalarArrayVal == other.scalarArrayVal &&
        rawVal == other.rawVal &&
        textVal == other.textVal &&
        textArrayVal == other.textArrayVal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, intVal.hashCode);
    _$hash = $jc(_$hash, scalarVal.hashCode);
    _$hash = $jc(_$hash, scalarArrayVal.hashCode);
    _$hash = $jc(_$hash, rawVal.hashCode);
    _$hash = $jc(_$hash, textVal.hashCode);
    _$hash = $jc(_$hash, textArrayVal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GDevValue')
          ..add('intVal', intVal)
          ..add('scalarVal', scalarVal)
          ..add('scalarArrayVal', scalarArrayVal)
          ..add('rawVal', rawVal)
          ..add('textVal', textVal)
          ..add('textArrayVal', textArrayVal))
        .toString();
  }
}

class GDevValueBuilder implements Builder<GDevValue, GDevValueBuilder> {
  _$GDevValue? _$v;

  int? _intVal;
  int? get intVal => _$this._intVal;
  set intVal(int? intVal) => _$this._intVal = intVal;

  double? _scalarVal;
  double? get scalarVal => _$this._scalarVal;
  set scalarVal(double? scalarVal) => _$this._scalarVal = scalarVal;

  ListBuilder<double>? _scalarArrayVal;
  ListBuilder<double> get scalarArrayVal =>
      _$this._scalarArrayVal ??= new ListBuilder<double>();
  set scalarArrayVal(ListBuilder<double>? scalarArrayVal) =>
      _$this._scalarArrayVal = scalarArrayVal;

  ListBuilder<int>? _rawVal;
  ListBuilder<int> get rawVal => _$this._rawVal ??= new ListBuilder<int>();
  set rawVal(ListBuilder<int>? rawVal) => _$this._rawVal = rawVal;

  String? _textVal;
  String? get textVal => _$this._textVal;
  set textVal(String? textVal) => _$this._textVal = textVal;

  ListBuilder<String>? _textArrayVal;
  ListBuilder<String> get textArrayVal =>
      _$this._textArrayVal ??= new ListBuilder<String>();
  set textArrayVal(ListBuilder<String>? textArrayVal) =>
      _$this._textArrayVal = textArrayVal;

  GDevValueBuilder();

  GDevValueBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _intVal = $v.intVal;
      _scalarVal = $v.scalarVal;
      _scalarArrayVal = $v.scalarArrayVal?.toBuilder();
      _rawVal = $v.rawVal?.toBuilder();
      _textVal = $v.textVal;
      _textArrayVal = $v.textArrayVal?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GDevValue other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GDevValue;
  }

  @override
  void update(void Function(GDevValueBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GDevValue build() => _build();

  _$GDevValue _build() {
    _$GDevValue _$result;
    try {
      _$result = _$v ??
          new _$GDevValue._(
              intVal: intVal,
              scalarVal: scalarVal,
              scalarArrayVal: _scalarArrayVal?.build(),
              rawVal: _rawVal?.build(),
              textVal: textVal,
              textArrayVal: _textArrayVal?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'scalarArrayVal';
        _scalarArrayVal?.build();
        _$failedField = 'rawVal';
        _rawVal?.build();

        _$failedField = 'textArrayVal';
        _textArrayVal?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GDevValue', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
