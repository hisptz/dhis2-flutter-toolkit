class D2InputFieldOption {
  String code;
  String name;
  int sortOrder;

  D2InputFieldOption({
    required this.code,
    required this.name,
    this.sortOrder = 0,
  });

  @override
  String toString() {
    return code;
  }
}
