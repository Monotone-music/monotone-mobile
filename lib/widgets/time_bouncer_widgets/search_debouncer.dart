import 'dart:async';
import 'dart:ui';

class SearchDebouncer {
  final Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  SearchDebouncer({this.delay = const Duration(milliseconds: 100)});

  void debounce(VoidCallback callback) {
    _callback = callback;
    cancel();
    _timer = Timer(delay, flush);
  }

  void cancel() {
    _timer?.cancel();
  }

  void flush() {
    _callback?.call();
    cancel();
  }
}