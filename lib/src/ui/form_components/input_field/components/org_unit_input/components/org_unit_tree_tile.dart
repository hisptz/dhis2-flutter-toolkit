import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:flutter/material.dart';

import '../models/org_unit_data.dart';

typedef ToggleSelection = Function(OrgUnitData data);

class OrgUnitTreeTile extends StatelessWidget {
  final bool multiple;
  final TreeNode<OrgUnitData> node;
  final List<String> selected;
  final Color color;
  final ToggleSelection toggleSelection;

  const OrgUnitTreeTile(
      {super.key,
      required this.multiple,
      required this.node,
      required this.selected,
      required this.color,
      required this.toggleSelection});

  TextStyle? getTextStyle() {
    if (selected.contains(node.data!.id)) {
      return TextStyle(fontWeight: FontWeight.bold, color: color);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: multiple
          ? Row(
              children: [
                Checkbox(
                    visualDensity: VisualDensity.compact,
                    value: selected.contains(node.data!.id),
                    onChanged: (value) {
                      toggleSelection(node.data!);
                    }),
                Text(
                  node.data!.displayName,
                  style: getTextStyle(),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 4, bottom: 4),
              child: Text(
                node.data!.displayName,
                style: getTextStyle(),
              ),
            ),
    );
  }
}
