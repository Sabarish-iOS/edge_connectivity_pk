import 'package:flutter/material.dart';

class EdgeConnectivityConfig {
  final Duration checkInterval;
  final Duration overlayDelay;
  final bool blockUserInteraction;

  final String title;
  final String description;
  final String retryText;

  final Color backgroundColor;
  final Color textColor;
  final Color retryButtonColor;

  final Widget Function(VoidCallback retry)? offlineBuilder;
  final Future<void> Function()? onRetry;
  final GlobalKey<NavigatorState>? navigatorKey;

  const EdgeConnectivityConfig({
    this.checkInterval = const Duration(seconds: 5),
    this.overlayDelay = const Duration(seconds: 2),
    this.blockUserInteraction = true,
    this.title = 'No Internet Connection',
    this.description = 'Please check your internet connection.',
    this.retryText = 'Retry',
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.retryButtonColor = Colors.blue,
    this.offlineBuilder,
    this.onRetry,
    this.navigatorKey,
  });
}
