import 'package:animated_tree_view/animated_tree_view.dart';

import '../org_unit_data.dart';

/// This class provides methods and properties for managing the selection
/// of organization units within a tree structure.
abstract class D2BaseOrgUnitSelectorService<T> {
  TreeNode<OrgUnitData>? _tree;
  TreeViewController<OrgUnitData, TreeNode<OrgUnitData>>? _controller;

  /// List of IDs representing the selected organization units.
  List<String>? selectedOrgUnits;

  /// Creates a new instance of [D2BaseOrgUnitSelectorService].
  ///
  /// [selectedOrgUnits]: List of IDs representing the initially selected organization units.
  D2BaseOrgUnitSelectorService({this.selectedOrgUnits});

  /// Returns the root tree node representing the organization unit hierarchy.
  TreeNode<OrgUnitData> get tree {
    if (_tree == null) {
      throw Exception("You need to call initialize first");
    }
    return _tree!;
  }

  /// Returns the controller used for managing the tree view.
  TreeViewController<OrgUnitData, TreeNode<OrgUnitData>> get controller {
    if (_controller == null) {
      throw Exception("Controller is not initialized");
    }
    return _controller!;
  }

  /// Retrieves the organization unit data from the provided organization unit.
  OrgUnitData getOrgUnitDataFromOrgUnit(T orgUnit);

  /// Retrieves the tree node representing the provided organization unit data.
  TreeNode<OrgUnitData> getTreeNodeFromOrgUnitData(OrgUnitData orgUnitData);

  setTree(TreeNode<OrgUnitData> tree) {
    _tree = tree;
  }

  setController(
      TreeViewController<OrgUnitData, TreeNode<OrgUnitData>> controller) {
    _controller = controller;
  }

  /// Retrieves the children of the provided tree node asynchronously.
  Future<List<TreeNode<OrgUnitData>>> getChildren(TreeNode<OrgUnitData> node);

  /// Initializes the service.
  Future<void> initialize();

  /// Retrieves the organization unit data corresponding to the provided IDs asynchronously.
  Future<List<OrgUnitData>> getOrgUnitDataFromId(List<String> values);

  /// Expands the initially selected nodes in the tree view.
  ///
  /// [initiallySelected]: List of IDs representing the initially selected nodes.
  void expandInitiallySelected({List<String>? initiallySelected}) {
    //TODO: Implement how to expand the selected nodes;
  }
}
