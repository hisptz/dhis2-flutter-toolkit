import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/components/org_unit_expansion_indicator.dart';
import 'package:flutter/material.dart';

import '../models/org_unit_data.dart';

class OrgUnitSelector extends StatefulWidget {
  final D2OrgUnitInputFieldConfig config;
  final List<String>? selectedOrgUnits;
  final OnChange<List<String>> onSelect;

  const OrgUnitSelector(
      {super.key,
      this.selectedOrgUnits = const [],
      required this.onSelect,
      required this.config});

  @override
  State<OrgUnitSelector> createState() => _OrgUnitSelectorState();
}

class _OrgUnitSelectorState extends State<OrgUnitSelector> {
  bool _loading = true;
  bool multiple = false;
  List<String> selectedOrgUnits = [];
  D2BaseOrgUnitSelectorService? service;

  initializeService() async {
    setState(() {
      _loading = true;
    });
    await service!.initialize();
    setState(() {
      _loading = false;
    });
  }

  toggleOrgUnitSelection(OrgUnitData orgUnitData) {
    if (selectedOrgUnits.contains(orgUnitData.id)) {
      setState(() {
        selectedOrgUnits = selectedOrgUnits
            .whereNot((orgUnitId) => orgUnitId == orgUnitData.id)
            .toList();
      });
    } else {
      setState(() {
        selectedOrgUnits.add(orgUnitData.id);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      service = widget.config.service;
      multiple = widget.config.multiple ?? false;
    });
    initializeService();
    setState(() {
      selectedOrgUnits = widget.selectedOrgUnits ?? [];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                : TreeView.simpleTyped<OrgUnitData, TreeNode<OrgUnitData>>(
                    indentation: const Indentation(),
                    expansionBehavior: ExpansionBehavior.collapseOthers,
                    expansionIndicatorBuilder: (BuildContext context, node) {
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
                      service!.setController(controller);
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
                    tree: service!.tree),
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
