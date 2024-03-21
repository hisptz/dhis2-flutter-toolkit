import '../../input_field/models/base_input_field.dart';

class D2FormSection {
  final String id;
  final String? title;
  final String? subtitle;
  final List<D2BaseInputFieldConfig> fields;

  D2FormSection({
    this.title,
    this.subtitle,
    required this.id,
    required this.fields,
  });
}
