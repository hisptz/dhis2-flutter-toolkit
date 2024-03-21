class OrgUnitData {
  String displayName;
  int level;
  bool hasChildren;
  String id;

  List<OrgUnitData>? children;

  OrgUnitData(
      {required this.displayName,
      required this.level,
      required this.hasChildren,
      this.children,
      required this.id});
}
