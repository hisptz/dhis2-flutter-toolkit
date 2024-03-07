class Pagination {
  int total;
  int pageSize;
  int pageCount;

  Pagination(
      {required this.total, required this.pageSize, required this.pageCount});

  Pagination.fromMap(Map json)
      : total = json["total"],
        pageSize = json["pageSize"],
        pageCount = json["pageCount"];
}
