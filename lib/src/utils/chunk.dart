class ChunkUtil {
  static List<List<T>> chunkItems<T>({
    List<T> items = const [],
    int size = 0,
  }) {
    List<List<T>> groupedItems = [];
    size = size != 0 ? size : items.length;
    for (var count = 1; count <= (items.length / size).ceil(); count++) {
      int start = (count - 1) * size;
      int end = (count * size);
      List<T> subList =
          items.sublist(start, end > items.length ? items.length : end);
      groupedItems.add(subList);
    }
    return groupedItems;
  }
}
