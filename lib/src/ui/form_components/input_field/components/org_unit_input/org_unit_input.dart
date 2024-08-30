import 'package:flutter/material.dart';

import '../../models/org_unit_input_field.dart';
import '../base_input.dart';
import '../input_field_icon.dart';
import 'components/org_unit_search.dart';
import 'components/org_unit_selector.dart';
import 'models/org_unit_data.dart';

class OrgUnitInput
    extends BaseStatelessInput<D2OrgUnitInputFieldConfig, String> {
  const OrgUnitInput({
    super.key,
    required super.input,
    required super.onChange,
    super.disabled,
    super.value,
    required super.color,
    required super.decoration,
  });

  final int maxLines = 2;

  void onSelect(List<String> selected) {
    onChange(selected.first);
  }

  onOpenSelector(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => OrgUnitSelector(
              limitSelectionTo: input.limitSelectionTo,
              key: UniqueKey(),
              color: color,
              config: input,
              onSelect: onSelect,
              selectedOrgUnits: value != null ? [value!] : [],
            ));
  }

  onOpenSearch(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => OrgUnitSearch(
              limitSelectionTo: input.limitSelectionTo,
              key: UniqueKey(),
              color: color,
              config: input,
              onSelect: onSelect,
              selectedOrgUnits: value != null ? [value!] : [],
            ));
  }

  List<OrgUnitData> getOrgUnits(String? value) {
    if (value == null) {
      return [];
    } else {
      return input.service.getOrgUnitDataFromIdSync([value]);
    }
  }

  String? getNames() {
    List<OrgUnitData> selectedOrgUnitData = getOrgUnits(value);
    return selectedOrgUnitData.isEmpty
        ? null
        : selectedOrgUnitData.map((orgUnit) => orgUnit.displayName).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          controller: TextEditingController(text: getNames()),
          cursorColor: color,
          enabled: !disabled,
          showCursor: false,
          autofocus: false,
          onTap: disabled
              ? null
              : () {
                  onOpenSelector(context);
                },
          maxLines: maxLines,
          keyboardType: TextInputType.none,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: input.searchable,
              child: IconButton(
                color: color,
                padding: EdgeInsets.zero,
                constraints: iconConstraints,
                onPressed: disabled
                    ? null
                    : () {
                        onOpenSearch(context);
                      },
                icon: InputFieldIcon(
                    backgroundColor: color,
                    iconColor: color,
                    iconData: Icons.search),
              ),
            ),
            IconButton(
              color: color,
              padding: EdgeInsets.zero,
              constraints: iconConstraints,
              onPressed: disabled
                  ? null
                  : () {
                      onOpenSelector(context);
                    },
              icon: InputFieldIcon(
                  backgroundColor: color,
                  iconColor: color,
                  iconData: Icons.account_tree),
            )
          ],
        )
      ],
    );
  }
}
