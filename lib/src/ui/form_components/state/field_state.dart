import '../input_field/components/base_input.dart';

class D2FieldState {
  bool? hidden;
  bool? disabled;
  bool? mandatory;
  dynamic value;
  String? error;
  String? warning;
  List<String> optionsToHide = [];
  List<String> optionsToShow = [];
  OnChange<dynamic> onChange;

  D2FieldState(
      {required this.onChange,
      this.hidden,
      this.optionsToHide = const [],
      this.optionsToShow = const [],
      this.mandatory,
      this.disabled,
      this.value,
      this.error,
      this.warning});
}
