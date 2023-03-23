// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_data.var.gql.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GStreamDataVars> _$gStreamDataVarsSerializer =
    new _$GStreamDataVarsSerializer();

class _$GStreamDataVarsSerializer
    implements StructuredSerializer<GStreamDataVars> {
  @override
  final Iterable<Type> types = const [GStreamDataVars, _$GStreamDataVars];
  @override
  final String wireName = 'GStreamDataVars';

  @override
  Iterable<Object?> serialize(Serializers serializers, GStreamDataVars object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'drfs',
      serializers.serialize(object.drfs,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  GStreamDataVars deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GStreamDataVarsBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'drfs':
          result.drfs.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$GStreamDataVars extends GStreamDataVars {
  @override
  final BuiltList<String> drfs;

  factory _$GStreamDataVars([void Function(GStreamDataVarsBuilder)? updates]) =>
      (new GStreamDataVarsBuilder()..update(updates))._build();

  _$GStreamDataVars._({required this.drfs}) : super._() {
    BuiltValueNullFieldError.checkNotNull(drfs, r'GStreamDataVars', 'drfs');
  }

  @override
  GStreamDataVars rebuild(void Function(GStreamDataVarsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GStreamDataVarsBuilder toBuilder() =>
      new GStreamDataVarsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GStreamDataVars && drfs == other.drfs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, drfs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GStreamDataVars')..add('drfs', drfs))
        .toString();
  }
}

class GStreamDataVarsBuilder
    implements Builder<GStreamDataVars, GStreamDataVarsBuilder> {
  _$GStreamDataVars? _$v;

  ListBuilder<String>? _drfs;
  ListBuilder<String> get drfs => _$this._drfs ??= new ListBuilder<String>();
  set drfs(ListBuilder<String>? drfs) => _$this._drfs = drfs;

  GStreamDataVarsBuilder();

  GStreamDataVarsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _drfs = $v.drfs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GStreamDataVars other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GStreamDataVars;
  }

  @override
  void update(void Function(GStreamDataVarsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GStreamDataVars build() => _build();

  _$GStreamDataVars _build() {
    _$GStreamDataVars _$result;
    try {
      _$result = _$v ?? new _$GStreamDataVars._(drfs: drfs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'drfs';
        drfs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'GStreamDataVars', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
