import '../../input_field/models/base_input_field.dart';

/// This class represents a section within a dynamic form, containing a list of fields.
class D2FormSection {
  /// Identifier of the form section.
  final String id;

  /// Title of the form section.
  final String? title;

  /// Subtitle of the form section.
  final String? subtitle;

  /// Sort order of the section within the form.
  final int sortOrder;

  /// List of input field configurations [D2BaseInputFieldConfig] within the section.
  final List<D2BaseInputFieldConfig> fields;

  /// Constructs a [D2FormSection] instance.
  /// - [id]: Identifier of the form section.
  /// - [fields]: List of input field configurations within the section.
  /// - [title]: Title of the form section.
  /// - [subtitle]: Subtitle of the form section.
  /// - [sortOrder]: Sort order of the section within the form (default is 0).
  D2FormSection({
    required this.id,
    required this.fields,
    this.title,
    this.subtitle,
    this.sortOrder = 0,
  });
}
