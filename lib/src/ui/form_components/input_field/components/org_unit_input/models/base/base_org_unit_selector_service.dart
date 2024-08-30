import 'package:animated_tree_view/animated_tree_view.dart';

import '../org_unit_data.dart';

abstract class D2BaseOrgUnitSelectorService<T> {
  TreeNode<OrgUnitData>? _tree;
  TreeViewController<OrgUnitData, TreeNode<OrgUnitData>>? _controller;
  List<String>? selectedOrgUnits;

  D2BaseOrgUnitSelectorService({this.selectedOrgUnits});

  TreeNode<OrgUnitData> get tree {
    if (_tree == null) {
      throw "You need to call initialize first";
    }
    return _tree!;
  }

  TreeViewController<OrgUnitData, TreeNode<OrgUnitData>> get controller {
    if (_controller == null) {
      throw "Controller is not initialized";
    }
    return _controller!;
  }

  OrgUnitData getOrgUnitDataFromOrgUnit(T orgUnit);

  TreeNode<OrgUnitData> getTreeNodeFromOrgUnitData(OrgUnitData orgUnitData);

  setTree(TreeNode<OrgUnitData> tree) {
    _tree = tree;
  }

  setController(
      TreeViewController<OrgUnitData, TreeNode<OrgUnitData>> controller) {
    _controller = controller;
  }

  Future<List<TreeNode<OrgUnitData>>> getChildren(TreeNode<OrgUnitData> node);

  Future<void> initialize();

  Future<List<OrgUnitData>> getOrgUnitDataFromId(List<String> values);

  List<OrgUnitData> getOrgUnitDataFromIdSync(List<String> values);

  Future<List<OrgUnitData>> searchOrgUnitDataFromKeyword(String keyword);

  void expandInitiallySelected({List<String>? initiallySelected}) {
    //TODO: Implement how to expand the selected nodes;
  }
}
