// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_edit_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskEditState {
  String get title;
  String? get description;
  String? get projectId;
  bool get isNew;
  String? get existingTaskId;

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskEditStateCopyWith<TaskEditState> get copyWith =>
      _$TaskEditStateCopyWithImpl<TaskEditState>(
          this as TaskEditState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskEditState &&
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

  @override
  String toString() {
    return 'TaskEditState(title: $title, description: $description, projectId: $projectId, isNew: $isNew, existingTaskId: $existingTaskId)';
  }
}

/// @nodoc
abstract mixin class $TaskEditStateCopyWith<$Res> {
  factory $TaskEditStateCopyWith(
          TaskEditState value, $Res Function(TaskEditState) _then) =
      _$TaskEditStateCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String? description,
      String? projectId,
      bool isNew,
      String? existingTaskId});
}

/// @nodoc
class _$TaskEditStateCopyWithImpl<$Res>
    implements $TaskEditStateCopyWith<$Res> {
  _$TaskEditStateCopyWithImpl(this._self, this._then);

  final TaskEditState _self;
  final $Res Function(TaskEditState) _then;

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
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _self.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      isNew: null == isNew
          ? _self.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      existingTaskId: freezed == existingTaskId
          ? _self.existingTaskId
          : existingTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TaskEditState].
extension TaskEditStatePatterns on TaskEditState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TaskEditState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskEditState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TaskEditState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEditState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TaskEditState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEditState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String title, String? description, String? projectId,
            bool isNew, String? existingTaskId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskEditState() when $default != null:
        return $default(_that.title, _that.description, _that.projectId,
            _that.isNew, _that.existingTaskId);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String title, String? description, String? projectId,
            bool isNew, String? existingTaskId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEditState():
        return $default(_that.title, _that.description, _that.projectId,
            _that.isNew, _that.existingTaskId);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String title, String? description, String? projectId,
            bool isNew, String? existingTaskId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskEditState() when $default != null:
        return $default(_that.title, _that.description, _that.projectId,
            _that.isNew, _that.existingTaskId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TaskEditState implements TaskEditState {
  const _TaskEditState(
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

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskEditStateCopyWith<_TaskEditState> get copyWith =>
      __$TaskEditStateCopyWithImpl<_TaskEditState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskEditState &&
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

  @override
  String toString() {
    return 'TaskEditState(title: $title, description: $description, projectId: $projectId, isNew: $isNew, existingTaskId: $existingTaskId)';
  }
}

/// @nodoc
abstract mixin class _$TaskEditStateCopyWith<$Res>
    implements $TaskEditStateCopyWith<$Res> {
  factory _$TaskEditStateCopyWith(
          _TaskEditState value, $Res Function(_TaskEditState) _then) =
      __$TaskEditStateCopyWithImpl;
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
class __$TaskEditStateCopyWithImpl<$Res>
    implements _$TaskEditStateCopyWith<$Res> {
  __$TaskEditStateCopyWithImpl(this._self, this._then);

  final _TaskEditState _self;
  final $Res Function(_TaskEditState) _then;

  /// Create a copy of TaskEditState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? projectId = freezed,
    Object? isNew = null,
    Object? existingTaskId = freezed,
  }) {
    return _then(_TaskEditState(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: freezed == projectId
          ? _self.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String?,
      isNew: null == isNew
          ? _self.isNew
          : isNew // ignore: cast_nullable_to_non_nullable
              as bool,
      existingTaskId: freezed == existingTaskId
          ? _self.existingTaskId
          : existingTaskId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
