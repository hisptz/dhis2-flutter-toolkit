import '../../form_section/models/form_section.dart';

class D2TrackerFormOptions {
  final bool showTitle;

  final List<D2FormSection> formSections;

  D2TrackerFormOptions({this.showTitle = false, this.formSections = const []});
}
