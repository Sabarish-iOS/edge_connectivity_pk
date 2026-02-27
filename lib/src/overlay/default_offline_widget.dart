import 'package:flutter/material.dart';
import '../config/edge_connectivity_config.dart';

class DefaultOfflineWidget extends StatelessWidget {
  final EdgeConnectivityConfig config;
  final VoidCallback onRetry;

  const DefaultOfflineWidget({
    super.key,
    required this.config,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: config.backgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            config.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: config.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            config.description,
            style: TextStyle(
              color: config.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: config.retryButtonColor,
            ),
            onPressed: onRetry,
            child: Text(config.retryText),
          ),
        ],
      ),
    );
  }
}