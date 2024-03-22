class ChunkUtil {
  static List<List<dynamic>> chunkItems({
    List<dynamic> items = const [],
    int size = 0,
  }) {
    List<List<dynamic>> groupedItems = [];
    size = size != 0 ? size : items.length;
    for (var count = 1; count <= (items.length / size).ceil(); count++) {
      int start = (count - 1) * size;
      int end = (count * size);
      List<dynamic> subList =
          items.sublist(start, end > items.length ? items.length : end);
      groupedItems.add(subList);
    }
    return groupedItems;
  }
}
