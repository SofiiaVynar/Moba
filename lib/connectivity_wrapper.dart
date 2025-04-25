import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final isNowConnected = result != ConnectivityResult.none;
      if (mounted && isNowConnected != _isConnected) {
        setState(() {
          _isConnected = isNowConnected;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNowConnected
                  ? 'Відновлено з’єднання з Інтернетом'
                  : 'Втрачено з’єднання з Інтернетом',
            ),
            duration: const Duration(seconds: 7),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
