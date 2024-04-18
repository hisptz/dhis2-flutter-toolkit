import 'dart:async';

class D2Debouncer {
  final int milliseconds;
  Timer? _timer;

  D2Debouncer({required this.milliseconds});

  void run(action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
