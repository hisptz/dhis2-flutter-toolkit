import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2TrackerFormOptions {
  final bool showTitle;
  final bool showSectionTitle;
  final bool clearable;

  final List<D2FormSection> formSections;

  D2TrackerFormOptions(
      {this.showTitle = true,
      this.formSections = const [],
      this.showSectionTitle = true,
      this.clearable = true});
}
