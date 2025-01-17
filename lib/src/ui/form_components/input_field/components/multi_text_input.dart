import 'dart:math';

import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/multi_text_input_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../models/input_field_option.dart';

class MultiTextInput
    extends BaseStatelessInput<D2MultiTextInputFieldConfig, String> {
  const MultiTextInput(
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
    return input.filteredOptions
        .map<Widget>((option) => Row(
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
                                      ?.split(",")
                                      .where((val) => val != option.code)
                                      .toList() ??
                                  [];
                              if (updatedValue.isEmpty) {
                                onChange(null);
                              } else {
                                onChange(updatedValue.join(","));
                              }
                            } else {
                              List<String> newValue = [
                                ...(value?.split(",") ?? []),
                                option.code
                              ];
                              onChange(newValue.join(","));
                            }
                          }),
                Flexible(child: Text(option.name))
              ],
            ))
        .toList();
  }

  Widget renderDropdown(BuildContext context) {
    List<D2InputFieldOption> optionNames = input.filteredOptions;
    List<D2InputFieldOption>? valueOptions = input.filteredOptions
        .where((D2InputFieldOption option) =>
            value?.split(',').contains(option.code) ?? false)
        .toList();
    final bool shouldShowSearch = optionNames.length >= 10;
    return DropdownSearch<D2InputFieldOption>.multiSelection(
      suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
        iconClosed: Transform.rotate(
          angle: -(pi / 2),
          child: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
        iconOpened: Transform.rotate(
          angle: (pi / 2),
          child: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
      )),
      popupProps: PopupPropsMultiSelection.menu(
        showSearchBox: shouldShowSearch,
        searchFieldProps: const TextFieldProps(
          autofocus: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Search here',
          ),
        ),
        onDismissed: () {
          FocusScope.of(context).unfocus();
        },
        fit: FlexFit.tight,
        constraints: BoxConstraints(
          maxHeight: min(MediaQuery.of(context).size.height * 0.5,
              ((optionNames.length * 60.0) + 60.0)),
        ),
      ),
      decoratorProps: const DropDownDecoratorProps(
          decoration: InputDecoration(
        border: InputBorder.none,
      )),
      enabled: !disabled,
      itemAsString: (D2InputFieldOption option) => option.name,
      items: (filter, loadProps) {
        return optionNames;
      },
      compareFn: (D2InputFieldOption? item, D2InputFieldOption? selectedItem) {
        return item?.name == selectedItem?.name;
      },
      onChanged: disabled
          ? null
          : (List<D2InputFieldOption>? selectedOptions) {
              List<String>? selected =
                  selectedOptions?.map((option) => option.code).toList();
              onChange(selected?.join(","));
              FocusScope.of(context).requestFocus(FocusNode());
            },
      selectedItems: valueOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (input.renderOptionsAsDropdown) {
      return renderDropdown(context);
    }
    return Wrap(
      alignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: getInputs(),
    );
  }
}
