// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_export_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DataExportState {
  String get csvName => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataExportStateCopyWith<DataExportState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataExportStateCopyWith<$Res> {
  factory $DataExportStateCopyWith(
          DataExportState value, $Res Function(DataExportState) then) =
      _$DataExportStateCopyWithImpl<$Res, DataExportState>;
  @useResult
  $Res call({String csvName});
}

/// @nodoc
class _$DataExportStateCopyWithImpl<$Res, $Val extends DataExportState>
    implements $DataExportStateCopyWith<$Res> {
  _$DataExportStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? csvName = null,
  }) {
    return _then(_value.copyWith(
      csvName: null == csvName
          ? _value.csvName
          : csvName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DummyDownloadStateImplCopyWith<$Res>
    implements $DataExportStateCopyWith<$Res> {
  factory _$$DummyDownloadStateImplCopyWith(_$DummyDownloadStateImpl value,
          $Res Function(_$DummyDownloadStateImpl) then) =
      __$$DummyDownloadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String csvName});
}

/// @nodoc
class __$$DummyDownloadStateImplCopyWithImpl<$Res>
    extends _$DataExportStateCopyWithImpl<$Res, _$DummyDownloadStateImpl>
    implements _$$DummyDownloadStateImplCopyWith<$Res> {
  __$$DummyDownloadStateImplCopyWithImpl(_$DummyDownloadStateImpl _value,
      $Res Function(_$DummyDownloadStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? csvName = null,
  }) {
    return _then(_$DummyDownloadStateImpl(
      csvName: null == csvName
          ? _value.csvName
          : csvName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DummyDownloadStateImpl implements _DummyDownloadState {
  const _$DummyDownloadStateImpl({this.csvName = ''});

  @override
  @JsonKey()
  final String csvName;

  @override
  String toString() {
    return 'DataExportState(csvName: $csvName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DummyDownloadStateImpl &&
            (identical(other.csvName, csvName) || other.csvName == csvName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, csvName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DummyDownloadStateImplCopyWith<_$DummyDownloadStateImpl> get copyWith =>
      __$$DummyDownloadStateImplCopyWithImpl<_$DummyDownloadStateImpl>(
          this, _$identity);
}

abstract class _DummyDownloadState implements DataExportState {
  const factory _DummyDownloadState({final String csvName}) =
      _$DummyDownloadStateImpl;

  @override
  String get csvName;
  @override
  @JsonKey(ignore: true)
  _$$DummyDownloadStateImplCopyWith<_$DummyDownloadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
