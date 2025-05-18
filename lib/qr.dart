import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class QRScannerScreen extends StatelessWidget {
  final void Function(String) onVerified;

  const QRScannerScreen({required this.onVerified, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканер QR-коду')),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue ?? '';
          if (code == 'valid_credentials_123') {
            onVerified(code);
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Неправильні креденшали!')),
            );
          }
        },
      ),
    );
  }
}
