import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/components/org_unit_search_results.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/components/selected_org_unit_list.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/models/org_unit_data.dart';
import 'package:flutter/material.dart';

import '../../../../../../utils/debounce.dart';
import '../../base_input.dart';

final debounce = D2Debouncer(milliseconds: 1000);

class OrgUnitSearch extends StatefulWidget {
  final D2OrgUnitInputFieldConfig config;
  final List<String>? selectedOrgUnits;
  final OnChange<List<String>> onSelect;
  final List<String> limitSelectionTo;

  final Color color;

  const OrgUnitSearch({
    super.key,
    required this.config,
    this.selectedOrgUnits,
    required this.onSelect,
    required this.color,
    required this.limitSelectionTo,
  });

  @override
  State<OrgUnitSearch> createState() => _OrgUnitSearchState();
}

class _OrgUnitSearchState extends State<OrgUnitSearch> {
  bool loading = false;
  bool multiple = false;
  late D2BaseOrgUnitSelectorService service;
  List<String> selectedOrgUnits = [];
  List<OrgUnitData> searchResults = [];
  TextEditingController keywordController = TextEditingController();
  String? keyword;

  toggleOrgUnitSelection(OrgUnitData orgUnitData) {
    bool disableSelection = getDisabledSelectionStatus(orgUnitData.id);
    if (disableSelection) {
      return;
    }

    if (selectedOrgUnits.contains(orgUnitData.id)) {
      setState(() {
        selectedOrgUnits = selectedOrgUnits
            .whereNot((orgUnitId) => orgUnitId == orgUnitData.id)
            .toList();
      });
    } else {
      if (multiple) {
        setState(() {
          selectedOrgUnits.add(orgUnitData.id);
        });
      } else {
        setState(() {
          selectedOrgUnits = [orgUnitData.id];
        });
      }
    }
  }

  bool getDisabledSelectionStatus(String id) {
    if (widget.limitSelectionTo.isEmpty) {
      return false;
    }
    return !widget.limitSelectionTo.contains(id);
  }

  onSearch() async {
    if (keyword == null) {
      return;
    }
    setState(() {
      loading = true;
    });
    List<OrgUnitData> results =
        (await service.searchOrgUnitDataFromKeyword(keyword!))
            .cast<OrgUnitData>();
    setState(() {
      searchResults = results
          .where((orgUnit) => !getDisabledSelectionStatus(orgUnit.id))
          .toList();
      loading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      service = widget.config.service;
      multiple = widget.config.multiple;
      selectedOrgUnits = widget.selectedOrgUnits ?? [];
    });
    keywordController.addListener(() {
      debounce.run(() {
        setState(() {
          if (keywordController.text.isEmpty) {
            keyword = null;
            searchResults = [];
          } else {
            keyword = keywordController.text;
          }
        });
        onSearch();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        scrollable: true,
        buttonPadding: const EdgeInsets.all(4.0),
        title: Text('${widget.config.label} search'),
        content: Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: keywordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Search'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SelectedOrgUnitList(
                        onDeselect: toggleOrgUnitSelection,
                        selectedOrgUnits: selectedOrgUnits,
                        service: service,
                        color: widget.color)),
                Expanded(
                    child: OrgUnitSearchResults(
                        service: service,
                        loading: false,
                        keyword: keyword,
                        multiple: multiple,
                        onSelect: toggleOrgUnitSelection,
                        searchResults: searchResults,
                        selectedOrgUnits: selectedOrgUnits,
                        color: widget.color))
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                widget.onSelect(selectedOrgUnits);
                Navigator.of(context).pop();
              },
              child: const Text("Select")),
        ]);
  }
}
