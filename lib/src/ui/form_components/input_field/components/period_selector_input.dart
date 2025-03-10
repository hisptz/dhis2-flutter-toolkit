import 'package:dhis2_flutter_toolkit/src/utils/period_engine/helpers/date.dart';
import 'package:flutter/material.dart';

import '../../../../utils/period_engine/models/period_filter_selection.dart';
import '../../../../utils/period_engine/models/period_type.dart';
import '../../../app_modals/utils/d2_app_modal_util.dart';
import '../../../period/period_filter.dart';
import '../models/period_selector_input_field.dart';
import 'base_input.dart';
import 'input_field_icon.dart';

class PeriodSelectorInput
    extends BaseStatelessInput<D2PeriodSelectorInputFieldConfig, List<String>> {
  PeriodSelectorInput({
    super.key,
    super.disabled,
    required super.input,
    required super.onChange,
    required super.color,
    super.value,
    required super.decoration,
  });

  final int maxLines = 1;

  void onOpenPeriodSelector(BuildContext context) {
    D2AppModalUtil.showActionSheetModal(context,
        title: input.selectorTitle ?? input.label,
        initialHeightRatio: 0.7,
        titleColor: color,
        actionSheetContainer: D2PeriodSelector(
          showFixed: input.showFixed,
          showRange: input.showRange,
          showRelative: input.showRelative,
          excludePeriodTypes: input.excludePeriodTypes,
          onlyAllowPeriodTypes: input.onlyAllowPeriodTypes,
          initialSelection: input.initialSelection,
          onUpdate: (D2PeriodSelection selection) {
            onChange(
                selection.selected != null && selection.selected!.isNotEmpty
                    ? selection.selected
                    : ["${selection.start}--${selection.end}"]);
            Navigator.of(context).pop();
          },
          color: color,
        ));
  }

  late final TextEditingController controller;

  String? getNames() {
    if ((value ?? []).any((dates) => dates.contains("--"))) {
      List<String> range = (value ?? []).first.split("--");
      final DateTime? startDate = DateTime.tryParse(range.first);
      final DateTime? endDate = DateTime.tryParse(range.last);

      return (startDate != null && endDate != null)
          ? "${formatDate(startDate)} - ${formatDate(endDate)}"
          : "";
    }

    return (value ?? []).map((String periodId) {
      return D2PeriodType.getPeriodById(periodId).name;
    }).join(', ');
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
                  onOpenPeriodSelector(context);
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
            IconButton(
              color: color,
              padding: EdgeInsets.zero,
              constraints: iconConstraints,
              onPressed: disabled
                  ? null
                  : () {
                      onOpenPeriodSelector(context);
                    },
              icon: InputFieldIcon(
                backgroundColor: color,
                iconColor: color,
                iconData: Icons.calendar_month,
              ),
            )
          ],
        )
      ],
    );
  }
}
