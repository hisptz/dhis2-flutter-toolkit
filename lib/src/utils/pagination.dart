class D2Pagination {
  int total;
  int pageSize;
  int pageCount;

  D2Pagination(
      {required this.total, required this.pageSize, required this.pageCount});

  D2Pagination.fromMap(Map json)
      : total = json["total"],
        pageSize = json["pageSize"],
        pageCount = json["pageCount"];
}
