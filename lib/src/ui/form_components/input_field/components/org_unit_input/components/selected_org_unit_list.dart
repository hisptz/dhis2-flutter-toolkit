import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/utils/color.dart';
import 'package:flutter/material.dart';

import '../models/org_unit_data.dart';

typedef OnDeselect = Function(OrgUnitData data);

class SelectedOrgUnitList extends StatelessWidget {
  final List<String> selectedOrgUnits;
  final D2BaseOrgUnitSelectorService service;
  final Color color;
  final OnDeselect onDeselect;

  const SelectedOrgUnitList(
      {super.key,
      required this.selectedOrgUnits,
      required this.service,
      required this.color,
      required this.onDeselect});

  List<OrgUnitData> getOrgUnits() {
    return service.getOrgUnitDataFromIdSync(selectedOrgUnits);
  }

  @override
  Widget build(BuildContext context) {
    List<OrgUnitData> orgUnitData = getOrgUnits();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Visibility(
        visible: selectedOrgUnits.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Selected",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: orgUnitData
                  .map((orgUnit) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: true,
                          selectedColor: color,
                          checkmarkColor: getTextColor(color),
                          labelStyle: TextStyle(color: getTextColor(color)),
                          deleteIconColor: getTextColor(color),
                          color: WidgetStateColor.resolveWith((_) => color),
                          onDeleted: () {
                            onDeselect(orgUnit);
                          },
                          label: Text(
                            orgUnit.displayName,
                          ),
                          onSelected: (bool value) {},
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
