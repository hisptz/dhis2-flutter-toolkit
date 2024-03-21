import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/components/org_unit_selector.dart';
import 'package:flutter/material.dart';

import '../base_input.dart';
import '../input_field_icon.dart';

class OrgUnitInput extends BaseInput<D2OrgUnitInputFieldConfig, List<String>> {
  final int? maxLines;

  OrgUnitInput({
    super.key,
    super.value,
    required super.input,
    required super.color,
    required super.onChange,
    this.maxLines = 1,
  });

  late final TextEditingController controller;
  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  void onSelect(List<String> selected) {
    onChange(selected);
  }

  onOpenSelector(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => OrgUnitSelector(
              color: color,
              config: input,
              onSelect: onSelect,
              selectedOrgUnits: value,
            ));
  }

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(text: value?.join(", "));
    return TextFormField(
      showCursor: false,
      controller: controller,
      onTap: () {
        onOpenSelector(context);
      },
      maxLines: maxLines,
      keyboardType: TextInputType.none,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            color: color,
            padding: EdgeInsets.zero,
            constraints: iconConstraints,
            onPressed: () {
              onOpenSelector(context);
            },
            icon: InputFieldIcon(
                backgroundColor: color,
                iconColor: color,
                iconData: Icons.account_tree),
          )),
    );
  }
}
