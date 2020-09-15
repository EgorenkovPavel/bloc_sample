part of '../bloc_list.dart';

class ListCubit<T> extends Cubit<PagedListAsyncState> {
  ListCubit(this.repository) : super(PagedListAsyncState(0));

  static const _limit = 10;

  final ListRepository<T> repository;

  Future<void> fetchItems() async {
    // ОБНОВЛЯЕМ STATE inProgress = true
    emit(PagedListAsyncState.inProgress(1));
    try {
      // ПОЛУЧАЕМ ДАННЫЕ
      final items = await repository.fetch(1, _limit);
      final isFinished = items.length < _limit;
      // ОБНОВЛЯЕМ STATE
      emit(PagedListAsyncState.success(1, List<dynamic>.unmodifiable(items), isFinished: isFinished));
    } catch (error) {
      // ОБРАБАТЫВАЕМ ОШИБКУ
      emit(PagedListAsyncState.error(0, error));
    }
  }

  Future<void> loadNextPage() async {
    // ПРОВЕРЯЕМ ТЕКУЩИЙ СТАТУС
    if (state.inProgress == true || state.isFinished == true) return;
    final nextPage = state.page + 1;
    // ОБНОВЛЯЕМ STATE inProgress = true
    emit(PagedListAsyncState.inProgress(nextPage, payload: state.payload));
    try {
      // ПОЛУЧАЕМ ДАННЫЕ
      final items = await repository.fetch(nextPage, _limit);
      final isFinished = items.length < _limit;
      final newItems = state.payload.toList()..addAll(items);
      emit(
          PagedListAsyncState.success(state.page, newItems, isFinished: isFinished));
      print('${state.payload.length}');
    } catch (error) {
      // ОБРАБАТЫВАЕМ ОШИБКУ
      final lastPage = state.page - 1;
      emit(PagedListAsyncState.error(lastPage, error, payload: state.payload));
    }
  }

  Future<void> addItem(T item) async {
    // СОЗДАЕМ ЗАДАЧУ
    final taskItem = ItemTask.create(item);
    final currentItems = state.payload?.toList() ?? [];
    // ДОБАВЛЯЕМ ЕЕ В НАЧАЛО СПИСКА
    currentItems.insert(0, taskItem);
    // ОБНОВЛЯЕМ STATE
    emit(PagedListAsyncState.success(state.page, currentItems));
    try {
      // ДЕЛАЕМ ЗАПРОС В РЕПОЗИТОРИЙ
      final itemFromRepository = await repository.add(item);
      // МЕНЯЕМ ЗАДАЧУ НА ПОЛУЧЕННУЮ МОДЕЛЬ ИЗ РЕПОЗИТОРИЯ
      final currentItems = state.payload.toList();
      final itemIndex = currentItems.indexOf(taskItem);
      currentItems[itemIndex] = itemFromRepository;
      // ОБНОВЛЯЕМ STATE
      emit(PagedListAsyncState.success(state.page, currentItems));
    } catch (e) {
      print(e);
      // СОЗДАЕМ ОШИБКУ В ЭЛЕМЕНТЕ И ОБНОВЛЯЕМ STATE
      final currentItems = state.payload.toList();
      final itemIndex = currentItems.indexOf(taskItem);
      currentItems[itemIndex] =
          taskItem.copyWith(taskStatus: AsyncState.error(e));
      emit(PagedListAsyncState.success(state.page, currentItems));
    }
  }

  Future<void> deleteItem(T item) async {
    // СОЗДАЕМ ЗАДАЧУ
    final currentItems = state.payload?.toList();
    final index = currentItems.indexOf(item);
    if (index == -1) throw ('Element not found');
    final taskItem = ItemTask.create(item);
    currentItems[index] = taskItem;
    // ОБНОВЛЯЕМ STATE
    emit(PagedListAsyncState.success(state.page, currentItems));
    try {
      // ДЕЛАЕМ ЗАПРОС В РЕПОЗИТОРИЙ
      final result = await repository.remove(item);
      if (result == true) {
        // УДАЛЯЕМ ПОЛЬЗОВАТЕЛЯ ИЗ СПИСКА
        final currentItems = state.payload?.toList();
        currentItems.remove(taskItem);
        emit(PagedListAsyncState.success(state.page, currentItems));
      } else {
        throw ('Result is false');
      }
    } catch (e) {
      print(e);
      // СОЗДАЕМ ОШИБКУ В ЭЛЕМЕНТЕ И ОБНОВЛЯЕМ STATE
      final currentItems = state.payload.toList();
      final itemIndex = currentItems.indexOf(taskItem);
      currentItems[itemIndex] =
          taskItem.copyWith(taskStatus: AsyncState.error(e));
      emit(PagedListAsyncState.success(state.page, currentItems));
    }
  }
}
