import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

import '../base_input.dart';
import '../input_field_icon.dart';
import 'components/org_unit_selector.dart';
import 'models/org_unit_data.dart';

class OrgUnitInput
    extends BaseStatefulInput<D2OrgUnitInputFieldConfig, List<String>> {
  final int? maxLines;

  const OrgUnitInput({
    super.key,
    super.value,
    required super.input,
    required super.color,
    required super.onChange,
    this.maxLines = 1,
  });

  @override
  State<StatefulWidget> createState() {
    return OrgUnitInputState();
  }
}

class OrgUnitInputState extends BaseStatefulInputState<OrgUnitInput> {
  List<OrgUnitData> selectedOrgUnitData = [];
  late final TextEditingController controller;
  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  void onSelect(List<String> selected) {
    widget.onChange(selected);
    loadSelectedNames(selected);
  }

  onOpenSelector(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => OrgUnitSelector(
              color: widget.color,
              config: widget.input,
              onSelect: onSelect,
              selectedOrgUnits: widget.value,
            ));
  }

  Future loadSelectedNames(List<String>? selected) async {
    controller.text = "...";
    List<OrgUnitData> orgUnits =
        await widget.input.service.getOrgUnitDataFromId(selected ?? []);
    setState(() {
      selectedOrgUnitData = orgUnits;
      controller.text = selectedOrgUnitData
          .map((OrgUnitData orgUnit) => orgUnit.displayName)
          .join(", ");
    });
  }

  @override
  void initState() {
    controller = TextEditingController();
    if (widget.value != null) {
      loadSelectedNames(widget.value);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    int? maxLines = widget.maxLines;

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
