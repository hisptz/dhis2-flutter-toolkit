class OrgUnitData {
  String displayName;
  int level;
  bool hasChildren;
  String id;
  String path;

  List<OrgUnitData>? children;

  OrgUnitData(
      {required this.displayName,
      required this.level,
      required this.hasChildren,
      this.children,
      required this.id,
      required this.path});
}
