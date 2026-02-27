import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/edge_connectivity_config.dart';
import 'default_offline_widget.dart';

class OverlayManager {
  OverlayEntry? _overlayEntry;

  /// Show the overlay
  void show({
    required EdgeConnectivityConfig config,
    required VoidCallback onRetry,
  }) {
    if (_overlayEntry != null) {
      debugPrint('[OverlayManager] Overlay already visible');
      return;
    }

    debugPrint('[OverlayManager] show() called');

    void tryInsertOverlay([int attempt = 0]) {
      final overlayContext = config.navigatorKey?.currentContext;
      debugPrint('[OverlayManager] attempt $attempt, overlayContext: $overlayContext');

      if (overlayContext == null) {
        if (attempt < 5) {
          // Retry on next frame
          WidgetsBinding.instance.addPostFrameCallback((_) => tryInsertOverlay(attempt + 1));
        } else {
          debugPrint('[OverlayManager] Failed to get overlayContext after 5 attempts');
        }
        return;
      }

      final overlayState = Overlay.of(overlayContext);
      if (overlayState == null) {
        debugPrint('[OverlayManager] Overlay.of returned null. Ensure MaterialApp or Navigator exists.');
        return;
      }

      _overlayEntry = OverlayEntry(
        builder: (_) {
          Widget child = config.offlineBuilder != null
              ? config.offlineBuilder!(onRetry)
              : DefaultOfflineWidget(config: config, onRetry: onRetry);

          if (config.blockUserInteraction) {
            child = AbsorbPointer(absorbing: true, child: child);
          }

          return Material(
            color: Colors.transparent,
            child: child,
          );
        },
      );

      overlayState.insert(_overlayEntry!);
      debugPrint('[OverlayManager] Overlay inserted successfully');
    }

    // Start insertion attempts
    tryInsertOverlay();
  }

  /// Hide the overlay
  void hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      debugPrint('[OverlayManager] Overlay removed');
    } else {
      debugPrint('[OverlayManager] hide() called but overlay was not visible');
    }
  }

  /// Check if overlay is visible
  bool get isVisible => _overlayEntry != null;
}