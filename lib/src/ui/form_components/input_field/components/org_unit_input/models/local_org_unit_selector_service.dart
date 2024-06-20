import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/models/org_unit_data.dart';

/// This is a service class for selecting local organizational units.
class D2LocalOrgUnitSelectorService
    extends D2BaseOrgUnitSelectorService<D2OrgUnit> {
  /// The ObjectBox database instance.
  D2ObjectBox db;

  /// The root nodes of the organizational unit tree.
  List<TreeNode<OrgUnitData>>? roots;

  /// Constructs a new instance of the [D2LocalOrgUnitSelectorService] class.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [initialRoots]: An optional list of initial root organizational units.
  D2LocalOrgUnitSelectorService(this.db, {List<OrgUnitData>? initialRoots}) {
    if (initialRoots != null) {
      roots = initialRoots.map(getTreeNodeFromOrgUnitData).toList();
    }
  }

  /// Initializes the root nodes of the organizational unit tree.
  initializeRoots() async {
    if (roots == null || roots!.isEmpty) {
      List<D2OrgUnit> rootOrgUnits =
          await D2OrgUnitRepository(db).getByLevel(1);
      List<OrgUnitData> orgUnitData =
          rootOrgUnits.map(getOrgUnitDataFromOrgUnit).toList();
      roots = orgUnitData
          .map<TreeNode<OrgUnitData>>(getTreeNodeFromOrgUnitData)
          .toList();
    }
  }

  /// Converts a [D2OrgUnit] instance to an [OrgUnitData] instance.
  ///
  /// - [orgUnit]: The organizational unit to convert.
  /// - Returns: The corresponding [OrgUnitData] instance.
  @override
  OrgUnitData getOrgUnitDataFromOrgUnit(D2OrgUnit orgUnit) {
    return OrgUnitData(
        displayName: orgUnit.displayName ?? orgUnit.name,
        level: orgUnit.level.target!.level,
        hasChildren: orgUnit.children.isNotEmpty,
        children: orgUnit.children.map(getOrgUnitDataFromOrgUnit).toList(),
        id: orgUnit.uid);
  }

  /// Converts an [OrgUnitData] instance to a [TreeNode] instance.
  ///
  /// - [orgUnitData]: The organizational unit data to convert.
  /// - Returns: The corresponding [TreeNode] instance.
  @override
  TreeNode<OrgUnitData> getTreeNodeFromOrgUnitData(OrgUnitData orgUnitData) {
    return TreeNode(key: orgUnitData.id, data: orgUnitData)
      ..addAll(orgUnitData.children?.map(getTreeNodeFromOrgUnitData) ?? []);
  }

  /// Initializes the service and sets up the organizational unit tree.
  ///
  /// This method should be called before using the service.
  @override
  Future initialize() async {
    await initializeRoots();
    if (roots != null) {
      setTree(TreeNode.root()..addAll(roots!));
    }
  }

  /// Retrieves the children of a given organizational unit node.
  ///
  /// - [node]: The node whose children are to be retrieved.
  /// - Returns: A list of [TreeNode] instances representing the children of the node.
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

  /// Retrieves the organizational unit data for a given list of IDs.
  ///
  /// - [values]: The list of IDs for which to retrieve organizational unit data.
  /// - Returns: A list of [OrgUnitData] instances corresponding to the given IDs.
  @override
  Future<List<OrgUnitData>> getOrgUnitDataFromId(List<String> values) async {
    List<D2OrgUnit> orgUnits = await D2OrgUnitRepository(db)
        .box
        .query(D2OrgUnit_.uid.oneOf(values))
        .build()
        .findAsync();

    return orgUnits.map(getOrgUnitDataFromOrgUnit).toList();
  }
}
