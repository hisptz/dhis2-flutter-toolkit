import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../models/org_unit_data.dart';

class OrgUnitExpansionIndicator extends ExpansionIndicator {
  OrgUnitExpansionIndicator(
      {super.key,
      required super.tree,
      super.alignment = Alignment.topRight,
      super.padding = EdgeInsets.zero,
      super.curve = Curves.ease,
      super.color});

  @override
  State<OrgUnitExpansionIndicator> createState() =>
      _OrgUnitExpansionIndicatorState();
}

class _OrgUnitExpansionIndicatorState extends State<OrgUnitExpansionIndicator> {
  @override
  Widget build(BuildContext context) {
    ITreeNode<OrgUnitData> tree = widget.tree as ITreeNode<OrgUnitData>;
    OrgUnitData? data = tree.data;

    if (data == null) {
      return Container();
    }

    return SizedBox.square(
      dimension: 24,
      child: !data.hasChildren
          ? Container()
          : tree.isExpanded
              ? const Icon(Icons.remove_circle_outline_sharp)
              : const Icon(Icons.add_circle_outline_sharp),
    );
  }
}
