import '../components/org_unit_input/models/base/base_org_unit_selector_service.dart';
import 'base_input_field.dart';

/// Configuration class for an organization unit input field.
class D2OrgUnitInputFieldConfig extends D2BaseInputFieldConfig {
  /// Service for selecting organization units.
  D2BaseOrgUnitSelectorService service;

  /// Constructs a [D2OrgUnitInputFieldConfig].
  ///
  /// - [label] Label for the input field.
  /// - [type] Type of the input field.
  /// - [name] Name of the input field.
  /// - [mandatory] Whether the input field is mandatory.
  /// - [clearable] (Optional) Whether the input field can be cleared.
  /// - [icon] (Optional) Icon for the input field.
  /// - [legends] (Optional) Legends associated with the input field.
  /// - [svgIconAsset] (Optional) SVG icon asset for the input field.
  /// - [service] Service for selecting organization units.
  D2OrgUnitInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      required this.service});
}
