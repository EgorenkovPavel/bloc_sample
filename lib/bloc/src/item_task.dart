part of '../bloc_list.dart';

class ItemTask<T> {
  ItemTask._(this.item, this.taskStatus);

  factory ItemTask.create(T item) =>
      ItemTask<T>._(item, AsyncState.inProgress());

  factory ItemTask.done(T item) =>
      ItemTask<T>._(item, AsyncState.success(true));

  factory ItemTask.error(T item, dynamic error) =>
      ItemTask<T>._(item, AsyncState.error(error));

  final T item;

  final AsyncState<bool> taskStatus;

  ItemTask copyWith({
    T item,
    AsyncState<bool> taskStatus,
  }) {
    if ((item == null || identical(item, this.item)) &&
        (taskStatus == null || identical(taskStatus, this.taskStatus))) {
      return this;
    }

    return ItemTask._(
      item ?? this.item,
      taskStatus ?? this.taskStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemTask &&
          runtimeType == other.runtimeType &&
          item == other.item &&
          taskStatus == other.taskStatus;

  @override
  int get hashCode => item.hashCode ^ taskStatus.hashCode;
}
