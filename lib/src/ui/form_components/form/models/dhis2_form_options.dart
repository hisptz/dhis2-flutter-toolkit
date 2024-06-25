import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

/// This is a class for configuring options, its behavior and appearance in a tracker form.
class D2TrackerFormOptions {
  /// Whether to show the title of the form.
  final bool showTitle;

  /// Whether to show titles for each form section.
  final bool showSectionTitle;

  /// Whether form fields should be clearable.
  final bool clearable;

  /// List of form sections to be included in the form.
  final List<D2FormSection> formSections;

  /// Constructs a new instance of [D2TrackerFormOptions].
  ///
  /// - [showTitle] Whether to show the title of the form. Default is `true`.
  /// - [showSectionTitle] Whether to show titles for each form section. Default is `true`.
  /// - [clearable] Whether form fields should be clearable. Default is `true`.
  /// - [formSections] List of form sections to be included in the form. Default is an empty list.
  D2TrackerFormOptions(
      {this.showTitle = true,
      this.formSections = const [],
      this.showSectionTitle = true,
      this.clearable = true});
}
