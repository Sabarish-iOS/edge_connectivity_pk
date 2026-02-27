import 'dart:async';
import 'package:get/get.dart';
import 'src/config/edge_connectivity_config.dart';
import 'src/core/edge_connectivity_controller.dart';
import 'src/models/connectivity_status.dart';

export 'src/config/edge_connectivity_config.dart';

class EdgeConnectivity {
  static late EdgeConnectivityController _controller;
  static final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();

  /// Stream to listen to connectivity status changes
  static Stream<ConnectivityStatus> get onStatusChanged =>
      _statusController.stream;

  /// Initialize the EdgeConnectivity package
  static void init({EdgeConnectivityConfig? config}) {
    final finalConfig = config ?? const EdgeConnectivityConfig();

    if (!Get.isRegistered<EdgeConnectivityController>()) {
      _controller = Get.put(
        EdgeConnectivityController(
          config: finalConfig,
          statusStream: _statusController,
        ),
      );
    }
  }

  /// Optional: manually trigger a connectivity check
  static Future<void> checkNow() async {
    await _controller.checkNow();
  }

  /// Optional: manually trigger retry logic
  static Future<void> retry() async {
    await _controller.retry();
  }
}
