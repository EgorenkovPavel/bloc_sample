part of '../bloc_list.dart';

Function iterableEquals = const ListEquality().equals;
Function iterableHash = const ListEquality().hash;

@immutable
class AsyncState<T> {
  const AsyncState({this.payload, this.inProgress = false, this.error});

  factory AsyncState.inProgress({T payload}) =>
      AsyncState(payload: payload, inProgress: true);

  factory AsyncState.error(dynamic error, {T payload}) =>
      AsyncState(payload: payload, inProgress: false, error: error);

  factory AsyncState.success(T payload) =>
      AsyncState(payload: payload, inProgress: false);

  final T payload;

  final bool inProgress;

  final Object error;

  bool get hasError => error != null;

  bool get hasData => payload != null;

  AsyncState copyWith({T payload, bool inProgress, dynamic error}) {
    if ((payload == null || identical(payload, this.payload)) &&
        (inProgress == null || identical(inProgress, this.inProgress)) &&
        (error == null || identical(error, this.error))) {
      return this;
    }

    return AsyncState(
      payload: payload ?? this.payload,
      inProgress: inProgress ?? this.inProgress,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncState &&
          runtimeType == other.runtimeType &&
          payload == other.payload &&
          inProgress == other.inProgress &&
          error == other.error;

  @override
  int get hashCode => payload.hashCode ^ inProgress.hashCode ^ error.hashCode;

  @override
  String toString() {
    return 'AsyncField{payload: $payload, inProgress: $inProgress, error: $error}';
  }
}

@immutable
class PagedListAsyncState<T> extends AsyncState<Iterable<T>> {
  final int page;
  final bool isFinished;

  const PagedListAsyncState(this.page,
      {Iterable<T> payload,
      bool inProgress = false,
      dynamic error,
      this.isFinished = false})
      : super(payload: payload, inProgress: inProgress, error: error);

  factory PagedListAsyncState.inProgress(int page, {Iterable<T> payload}) =>
      PagedListAsyncState(page, payload: payload, inProgress: true);

  factory PagedListAsyncState.error(int page, dynamic error,
          {Iterable<T> payload}) =>
      PagedListAsyncState(page,
          payload: payload, inProgress: false, error: error);

  factory PagedListAsyncState.success(int page, Iterable<T> payload,
          {bool isFinished = false}) =>
      PagedListAsyncState(page,
          payload: payload, inProgress: false, isFinished: isFinished);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PagedListAsyncState &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          inProgress == other.inProgress &&
          error == other.error &&
          isFinished == other.isFinished &&
          iterableEquals(payload, other.payload);

  @override
  int get hashCode =>
      error.hashCode ^
      inProgress.hashCode ^
      page.hashCode ^
      isFinished.hashCode ^
      identityHashCode(payload);

  @override
  String toString() {
    return '$runtimeType{page: $page, isFinished: $isFinished,error:$error, itemsCount:${payload?.length},inProgress:$inProgress';
  }
}
