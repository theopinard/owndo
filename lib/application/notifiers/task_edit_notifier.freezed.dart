// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_edit_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaskEditState {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get projectId => throw _privateConstructorUsedError;
  bool get isNew => throw _privateConstructorUsedError;
  String? get existingTaskId => throw _privateConstructorUsedError;

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskEditStateCopyWith<TaskEditState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEditStateCopyWith<$Res> {
  factory $TaskEditStateCopyWith(
          TaskEditState value, $Res Function(TaskEditState) then) =
      _$TaskEditStateCopyWithImpl<$Res, TaskEditState>;
  @useResult
  $Res call(
      {String title,
      String? description,
      String? projectId,
      bool isNew,
      String? existingTaskId});
}

/// @nodoc
class _$TaskEditStateCopyWithImpl<$Res, $Val extends TaskEditState>
    implements $TaskEditStateCopyWith<$Res> {
  _$TaskEditStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? projectId = freezed,
    Object? isNew = null,
    Object? existingTaskId = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      existingTaskId: freezed == existingTaskId
          ? _value.existingTaskId
          : existingTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskEditStateImplCopyWith<$Res>
    implements $TaskEditStateCopyWith<$Res> {
  factory _$$TaskEditStateImplCopyWith(
          _$TaskEditStateImpl value, $Res Function(_$TaskEditStateImpl) then) =
      __$$TaskEditStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      String? projectId,
      bool isNew,
      String? existingTaskId});
}

/// @nodoc
class __$$TaskEditStateImplCopyWithImpl<$Res>
    extends _$TaskEditStateCopyWithImpl<$Res, _$TaskEditStateImpl>
    implements _$$TaskEditStateImplCopyWith<$Res> {
  __$$TaskEditStateImplCopyWithImpl(
      _$TaskEditStateImpl _value, $Res Function(_$TaskEditStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? projectId = freezed,
    Object? isNew = null,
    Object? existingTaskId = freezed,
  }) {
    return _then(_$TaskEditStateImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      isNew: null == isNew
          ? _value.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      existingTaskId: freezed == existingTaskId
          ? _value.existingTaskId
          : existingTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TaskEditStateImpl implements _TaskEditState {
  const _$TaskEditStateImpl(
      {required this.title,
      this.description,
      this.projectId,
      required this.isNew,
      this.existingTaskId});

  @override
  final String title;
  @override
  final String? description;
  @override
  final String? projectId;
  @override
  final bool isNew;
  @override
  final String? existingTaskId;

  @override
  String toString() {
    return 'TaskEditState(title: $title, description: $description, projectId: $projectId, isNew: $isNew, existingTaskId: $existingTaskId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEditStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.isNew, isNew) || other.isNew == isNew) &&
            (identical(other.existingTaskId, existingTaskId) ||
                other.existingTaskId == existingTaskId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, projectId, isNew, existingTaskId);

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEditStateImplCopyWith<_$TaskEditStateImpl> get copyWith =>
      __$$TaskEditStateImplCopyWithImpl<_$TaskEditStateImpl>(this, _$identity);
}

abstract class _TaskEditState implements TaskEditState {
  const factory _TaskEditState(
      {required final String title,
      final String? description,
      final String? projectId,
      required final bool isNew,
      final String? existingTaskId}) = _$TaskEditStateImpl;

  @override
  String get title;
  @override
  String? get description;
  @override
  String? get projectId;
  @override
  bool get isNew;
  @override
  String? get existingTaskId;

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskEditStateImplCopyWith<_$TaskEditStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
