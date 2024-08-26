import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/multi_select_input_field.dart';
import 'package:flutter/material.dart';

import '../models/input_field_option.dart';

class MultiSelectInput
    extends BaseStatelessInput<D2MultiSelectInputFieldConfig, List<String>> {
  const MultiSelectInput(
      {super.key,
      super.value,
      super.disabled,
      required super.input,
      required super.onChange,
      required super.color,
      required super.decoration});

  bool isOptionSelected(D2InputFieldOption option) {
    if (value == null) {
      return false;
    }
    if (value!.isEmpty) {
      return false;
    }
    return value!.contains(option.code);
  }

  List<Widget> getInputs() {
    return input.options
            ?.map<Widget>((option) => Row(
                  mainAxisSize:
                      input.horizontal ? MainAxisSize.min : MainAxisSize.max,
                  children: [
                    Checkbox(
                        activeColor: color,
                        overlayColor:
                            WidgetStatePropertyAll(decoration.colorScheme.text),
                        fillColor: WidgetStatePropertyAll(
                          isOptionSelected(option)
                              ? disabled
                                  ? decoration.colorScheme.disabled
                                  : decoration.colorScheme.active
                              : Colors.transparent,
                        ),
                        value: isOptionSelected(option),
                        onChanged: disabled
                            ? null
                            : (checked) {
                                if (isOptionSelected(option)) {
                                  List<String> updatedValue = value
                                          ?.where((val) => val != option.code)
                                          .toList() ??
                                      [];
                                  if (updatedValue.isEmpty) {
                                    onChange(null);
                                  } else {
                                    onChange(updatedValue);
                                  }
                                } else {
                                  onChange([...(value ?? []), option.code]);
                                }
                              }),
                    Flexible(child: Text(option.name))
                  ],
                ))
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: getInputs(),
    );
  }
}
