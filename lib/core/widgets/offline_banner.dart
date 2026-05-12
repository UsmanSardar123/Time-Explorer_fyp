import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeexplorer/core/providers/connectivity_provider.dart';

/// Drop this above any Scaffold body to show an animated offline strip.
class OfflineBanner extends StatelessWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isOffline = context.watch<ConnectivityProvider>().isOffline;
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isOffline
              ? Container(
                  width: double.infinity,
                  color: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'You are offline — showing cached content',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Expanded(child: child),
      ],
    );
  }
}
