import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/models/org_unit_data.dart';

class D2LocalOrgUnitSelectorService extends D2BaseOrgUnitSelectorService {
  D2ObjectBox db;
  List<TreeNode<OrgUnitData>>? roots;

  D2LocalOrgUnitSelectorService(this.db, {List<OrgUnitData>? initialRoots}) {
    if (initialRoots != null) {
      roots = initialRoots.map(getTreeNodeFromOrgUnitData).toList();
    }
  }

  initializeRoots() async {
    if (roots == null) {
      List<D2OrgUnit> rootOrgUnits =
          await D2OrgUnitRepository(db).getByLevel(1);
      List<OrgUnitData> orgUnitData =
          rootOrgUnits.map(getOrgUnitDataFromOrgUnit).toList();
      roots = orgUnitData
          .map<TreeNode<OrgUnitData>>(getTreeNodeFromOrgUnitData)
          .toList();
    }
  }

  OrgUnitData getOrgUnitDataFromOrgUnit(D2OrgUnit orgUnit) {
    return OrgUnitData(
        displayName: orgUnit.displayName ?? orgUnit.name,
        level: orgUnit.level.target!.level,
        hasChildren: orgUnit.children.isNotEmpty,
        children: orgUnit.children.map(getOrgUnitDataFromOrgUnit).toList(),
        id: orgUnit.uid);
  }

  TreeNode<OrgUnitData> getTreeNodeFromOrgUnitData(OrgUnitData orgUnitData) {
    return TreeNode(key: orgUnitData.id, data: orgUnitData)
      ..addAll(orgUnitData.children?.map(getTreeNodeFromOrgUnitData) ?? [])
      ..addListener(() {
        print("Why");
      });
  }

  @override
  Future initialize() async {
    await initializeRoots();
    if (roots != null) {
      setTree(TreeNode.root()..addAll(roots!));
    }
  }

  @override
  Future<List<TreeNode<OrgUnitData>>> getChildren(
      TreeNode<OrgUnitData> node) async {
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db).getByUid(node.data!.id);
    if (orgUnit != null) {
      return orgUnit.children
          .map(getOrgUnitDataFromOrgUnit)
          .map(getTreeNodeFromOrgUnitData)
          .toList();
    }
    return [];
  }
}
