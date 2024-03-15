import 'field_state.dart';

class SectionState {
  String id;
  bool? hidden;
  bool? error;
  bool? warning;
  List<FieldState> fieldsStates;

  SectionState(
      {required this.id,
      this.hidden,
      this.error,
      this.warning,
      required this.fieldsStates});
}
