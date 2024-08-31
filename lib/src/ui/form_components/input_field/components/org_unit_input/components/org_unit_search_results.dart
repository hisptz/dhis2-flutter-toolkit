import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/base/base_org_unit_selector_service.dart';
import '../models/org_unit_data.dart';

typedef OnSelect = Function(OrgUnitData data);

class OrgUnitListTile extends StatelessWidget {
  final D2BaseOrgUnitSelectorService service;
  final OrgUnitData orgUnitData;
  final List<String> selectedOrgUnits;
  final Color color;
  final OnSelect onSelect;
  final bool multiple;

  const OrgUnitListTile({
    super.key,
    required this.orgUnitData,
    required this.selectedOrgUnits,
    required this.color,
    required this.onSelect,
    required this.multiple,
    required this.service,
  });

  get selected {
    return selectedOrgUnits.contains(orgUnitData.id);
  }

  List<OrgUnitData> getHierarchy() {
    return service
        .getOrgUnitDataFromIdSync(orgUnitData.path.split("/").sublist(1));
  }

  @override
  Widget build(BuildContext context) {
    List<OrgUnitData> hierarchy = getHierarchy();
    return ListTile(
      dense: true,
      isThreeLine: true,
      onTap: () {
        onSelect(orgUnitData);
      },
      selectedColor: color,
      selectedTileColor: color.withOpacity(0.4),
      leading: multiple
          ? Checkbox(
              visualDensity: VisualDensity.compact,
              value: selected,
              onChanged: (value) {
                onSelect(orgUnitData);
              })
          : selected
              ? const Icon(Icons.check)
              : const Icon(
                  Icons.account_tree,
                  size: 16,
                ),
      title: Text(orgUnitData.displayName,
          style: selected
              ? TextStyle(color: color, fontWeight: FontWeight.bold)
              : null),
      subtitle: Text(
        hierarchy
            .whereNot((orgUnit) => orgUnit.id == orgUnitData.id)
            .map((orgUnitData) => orgUnitData.displayName)
            .join("/ "),
        style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
      ),
    );
  }
}

class OrgUnitSearchResults extends StatelessWidget {
  final D2BaseOrgUnitSelectorService service;
  final List<OrgUnitData> searchResults;
  final List<String> selectedOrgUnits;
  final Color color;
  final String? keyword;
  final bool loading;
  final bool multiple;
  final OnSelect onSelect;

  const OrgUnitSearchResults(
      {super.key,
      required this.searchResults,
      required this.selectedOrgUnits,
      required this.color,
      this.keyword,
      required this.loading,
      required this.multiple,
      required this.onSelect,
      required this.service});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (keyword == null) {
      return const Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 32,
          ),
          Text('You can search for name, code or id'),
        ],
      ));
    }

    if (keyword != null && searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 32,
            ),
            Text('Could not find item with keyword $keyword'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Search Results",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OrgUnitListTile(
                    service: service,
                    onSelect: onSelect,
                    multiple: multiple,
                    orgUnitData: searchResults[index],
                    selectedOrgUnits: selectedOrgUnits,
                    color: color);
              },
              separatorBuilder: (context, index) {
                return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2));
              },
              itemCount: searchResults.length),
        )
      ],
    );
  }
}
