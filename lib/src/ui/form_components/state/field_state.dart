import '../input_field/components/base_input.dart';

class FieldState {
  bool? hidden;
  bool? disabled;
  bool? mandatory;
  dynamic value;
  String? error;
  String? warning;
  OnChange<dynamic> onChange;

  FieldState(
      {required this.onChange,
      this.hidden,
      this.mandatory,
      this.disabled,
      this.value,
      this.error,
      this.warning});
}
