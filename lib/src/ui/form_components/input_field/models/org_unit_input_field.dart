import '../components/org_unit_input/models/base/base_org_unit_selector_service.dart';
import 'base_input_field.dart';

class D2OrgUnitInputFieldConfig extends D2BaseInputFieldConfig {
  D2BaseOrgUnitSelectorService service;
  final List<String> limitSelectionTo;

  D2OrgUnitInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      required this.service,
      this.limitSelectionTo = const []});
}
