import 'package:animated_tree_view/animated_tree_view.dart';

import '../org_unit_data.dart';

abstract class D2BaseOrgUnitSelectorService {
  TreeNode<OrgUnitData>? _tree;
  TreeViewController<OrgUnitData, TreeNode<OrgUnitData>>? _controller;

  TreeNode<OrgUnitData> get tree {
    if (_tree == null) {
      throw "You need to call initialize first";
    }
    return _tree!;
  }

  setTree(TreeNode<OrgUnitData> tree) {
    _tree = tree;
  }

  setController(
      TreeViewController<OrgUnitData, TreeNode<OrgUnitData>> controller) {
    _controller = controller;
  }

  Future<List<TreeNode<OrgUnitData>>> getChildren(TreeNode<OrgUnitData> node);

  Future<void> initialize();
}
