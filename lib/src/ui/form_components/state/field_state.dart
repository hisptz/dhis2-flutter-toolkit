import '../input_field/components/base_input.dart';

class FieldState {
  bool? hidden;
  bool? mandatory;
  String? value;
  String? error;
  String? warning;
  OnChange<String?> onChange;

  FieldState(
      {required this.onChange,
      this.hidden,
      this.mandatory,
      this.value,
      this.error,
      this.warning});
}
