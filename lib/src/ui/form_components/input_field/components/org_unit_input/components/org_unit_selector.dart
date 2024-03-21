import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/components/custom_expansion_indicator.dart';
import 'package:flutter/material.dart';

import '../models/base/base_org_unit_selector_service.dart';
import '../models/org_unit_data.dart';

class OrgUnitSelector extends StatefulWidget {
  final D2BaseOrgUnitSelectorService service;

  const OrgUnitSelector({super.key, required this.service});

  @override
  State<OrgUnitSelector> createState() => _OrgUnitSelectorState();
}

class _OrgUnitSelectorState extends State<OrgUnitSelector> {
  bool _loading = true;

  initializeService() async {
    setState(() {
      _loading = true;
    });
    await widget.service.initialize();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    initializeService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    D2BaseOrgUnitSelectorService service = widget.service;
    return AlertDialog(
        title: const Text("Select organisation unit"),
        content: Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: TreeView.simpleTyped<OrgUnitData,
                            TreeNode<OrgUnitData>>(
                        indentation: const Indentation(),
                        expansionBehavior: ExpansionBehavior.collapseOthers,
                        expansionIndicatorBuilder:
                            (BuildContext context, node) {
                          if (node.data.hasChildren) {
                            if (node.isExpanded) {
                              return OrgUnitExpansionIndicator(
                                tree: node,
                                alignment: Alignment.centerLeft,
                              );
                            } else {
                              return OrgUnitExpansionIndicator(
                                tree: node,
                                alignment: Alignment.centerLeft,
                              );
                            }
                          }
                          return NoExpansionIndicator(tree: node);
                        },
                        showRootNode: false,
                        shrinkWrap: true,
                        onTreeReady: (controller) {
                          service.setController(controller);
                        },
                        builder:
                            (BuildContext context, TreeNode<OrgUnitData> node) {
                          if (node.data != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 8.0),
                              child: Text(node.data!.displayName),
                            );
                          }
                          return const Text("Root");
                        },
                        tree: service.tree),
                  ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel")),
          TextButton(onPressed: () {}, child: const Text("Select")),
        ]);
  }
}
