import 'dart:async';
import 'package:get/get.dart';
import '../config/edge_connectivity_config.dart';
import '../models/connectivity_status.dart';
import 'connectivity_service.dart';
import 'lifecycle_service.dart';
import '../overlay/overlay_manager.dart';

class EdgeConnectivityController extends GetxController {
  final EdgeConnectivityConfig config;
  final StreamController<ConnectivityStatus> statusStream;

  EdgeConnectivityController({
    required this.config,
    required this.statusStream,
  });

  final ConnectivityService _connectivityService = ConnectivityService();
  final OverlayManager _overlayManager = OverlayManager();

  late final LifecycleService _lifecycleService;

  final RxBool _isConnected = true.obs;

  Timer? _periodicTimer;
  Timer? _overlayDelayTimer;

  @override
  void onInit() {
    super.onInit();

    _lifecycleService = LifecycleService(
      onResumed: _onResumed,
      onPaused: _onPaused,
    );

    _lifecycleService.init();
    _startMonitoring();
  }

  @override
  void onClose() {
    _periodicTimer?.cancel();
    _overlayDelayTimer?.cancel();
    _lifecycleService.dispose();
    super.onClose();
  }

  void _onResumed() {
    checkNow();
    _startMonitoring();
  }

  void _onPaused() {
    _periodicTimer?.cancel();
  }

  void _startMonitoring() {
    _periodicTimer?.cancel();

    _periodicTimer = Timer.periodic(
      config.checkInterval,
      (_) => checkNow(),
    );
  }

  Future<void> checkNow() async {
    final hasInternet = await _connectivityService.hasInternet();

    if (hasInternet) {
      _handleConnected();
    } else {
      _handleDisconnected();
    }
  }

  void _handleConnected() {
    if (_isConnected.value) return;

    _isConnected.value = true;
    _overlayDelayTimer?.cancel();
    _overlayManager.hide();

    statusStream.add(ConnectivityStatus.connected);
  }

  void _handleDisconnected() {
    if (!_isConnected.value) return;

    _isConnected.value = false;

    statusStream.add(ConnectivityStatus.disconnected);

    _overlayDelayTimer?.cancel();
    _overlayDelayTimer = Timer(config.overlayDelay, () {
      if (!_isConnected.value && !_overlayManager.isVisible) {
        _overlayManager.show(
          config: config,
          onRetry: retry,
        );
      }
    });
  }

  Future<void> retry() async {
    if (config.onRetry != null) {
      await config.onRetry!();
    }

    await checkNow();
  }
}