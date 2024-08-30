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
  final bool disabledSelection;

  const OrgUnitTreeTile(
      {super.key,
      this.disabledSelection = false,
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
                disabledSelection
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 4),
                        child: Opacity(
                          opacity: disabledSelection ? 0.6 : 1,
                          child: const Icon(
                            applyTextScaling: true,
                            Icons.block,
                            size: 24,
                          ),
                        ),
                      )
                    : Checkbox(
                        visualDensity: VisualDensity.compact,
                        value: selected.contains(node.data!.id),
                        onChanged: (value) {
                          toggleSelection(node.data!);
                        }),
                Opacity(
                  opacity: disabledSelection ? 0.6 : 1,
                  child: Text(
                    node.data!.displayName,
                    style: getTextStyle(),
                  ),
                )
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(left: 32.0, top: 4, bottom: 4),
              child: Opacity(
                opacity: disabledSelection ? 0.6 : 1,
                child: Text(
                  node.data!.displayName,
                  style: getTextStyle(),
                ),
              ),
            ),
    );
  }
}
