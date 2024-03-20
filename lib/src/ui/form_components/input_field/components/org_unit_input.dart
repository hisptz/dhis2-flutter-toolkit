import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import 'base_input.dart';
import 'input_field_icon.dart';

class OrgUnitInput extends BaseInput<D2BaseInputFieldConfig, String> {
  final int? maxLines;

  const OrgUnitInput({
    super.key,
    super.value,
    required super.input,
    required super.color,
    required super.onChange,
    this.maxLines = 1,
  });

  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      showCursor: false,
      initialValue: value,
      onChanged: (String? value) {
        onChange(value);
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
            onPressed: () {},
            icon: InputFieldIcon(
                backgroundColor: color,
                iconColor: color,
                iconData: Icons.account_tree),
          )),
    );
  }
}
