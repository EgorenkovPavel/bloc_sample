abstract class ListRepository<T> {
  Future<Iterable<T>> fetch(int page, int limit);

  Future<T> add(T item);

  Future<bool> remove(T item);
}
