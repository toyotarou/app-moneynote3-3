// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_download_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DataDownloadResponseState {
  String get startDate => throw _privateConstructorUsedError;
  String get endDate => throw _privateConstructorUsedError;
  DateDownloadDataType? get dataType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DataDownloadResponseStateCopyWith<DataDownloadResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataDownloadResponseStateCopyWith<$Res> {
  factory $DataDownloadResponseStateCopyWith(DataDownloadResponseState value,
          $Res Function(DataDownloadResponseState) then) =
      _$DataDownloadResponseStateCopyWithImpl<$Res, DataDownloadResponseState>;
  @useResult
  $Res call({String startDate, String endDate, DateDownloadDataType? dataType});
}

/// @nodoc
class _$DataDownloadResponseStateCopyWithImpl<$Res,
        $Val extends DataDownloadResponseState>
    implements $DataDownloadResponseStateCopyWith<$Res> {
  _$DataDownloadResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? dataType = freezed,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: freezed == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as DateDownloadDataType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataDownloadResponseStateImplCopyWith<$Res>
    implements $DataDownloadResponseStateCopyWith<$Res> {
  factory _$$DataDownloadResponseStateImplCopyWith(
          _$DataDownloadResponseStateImpl value,
          $Res Function(_$DataDownloadResponseStateImpl) then) =
      __$$DataDownloadResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String startDate, String endDate, DateDownloadDataType? dataType});
}

/// @nodoc
class __$$DataDownloadResponseStateImplCopyWithImpl<$Res>
    extends _$DataDownloadResponseStateCopyWithImpl<$Res,
        _$DataDownloadResponseStateImpl>
    implements _$$DataDownloadResponseStateImplCopyWith<$Res> {
  __$$DataDownloadResponseStateImplCopyWithImpl(
      _$DataDownloadResponseStateImpl _value,
      $Res Function(_$DataDownloadResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? dataType = freezed,
  }) {
    return _then(_$DataDownloadResponseStateImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      dataType: freezed == dataType
          ? _value.dataType
          : dataType // ignore: cast_nullable_to_non_nullable
              as DateDownloadDataType?,
    ));
  }
}

/// @nodoc

class _$DataDownloadResponseStateImpl implements _DataDownloadResponseState {
  const _$DataDownloadResponseStateImpl(
      {this.startDate = '', this.endDate = '', this.dataType});

  @override
  @JsonKey()
  final String startDate;
  @override
  @JsonKey()
  final String endDate;
  @override
  final DateDownloadDataType? dataType;

  @override
  String toString() {
    return 'DataDownloadResponseState(startDate: $startDate, endDate: $endDate, dataType: $dataType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataDownloadResponseStateImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.dataType, dataType) ||
                other.dataType == dataType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate, dataType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataDownloadResponseStateImplCopyWith<_$DataDownloadResponseStateImpl>
      get copyWith => __$$DataDownloadResponseStateImplCopyWithImpl<
          _$DataDownloadResponseStateImpl>(this, _$identity);
}

abstract class _DataDownloadResponseState implements DataDownloadResponseState {
  const factory _DataDownloadResponseState(
      {final String startDate,
      final String endDate,
      final DateDownloadDataType? dataType}) = _$DataDownloadResponseStateImpl;

  @override
  String get startDate;
  @override
  String get endDate;
  @override
  DateDownloadDataType? get dataType;
  @override
  @JsonKey(ignore: true)
  _$$DataDownloadResponseStateImplCopyWith<_$DataDownloadResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
