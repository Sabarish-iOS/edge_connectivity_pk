import 'package:flutter/widgets.dart';

class LifecycleService with WidgetsBindingObserver {
  final VoidCallback onResumed;
  final VoidCallback onPaused;

  LifecycleService({
    required this.onResumed,
    required this.onPaused,
  });

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    } else if (state == AppLifecycleState.paused) {
      onPaused();
    }
  }
}