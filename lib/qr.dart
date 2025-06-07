import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final void Function(String) onVerified;

  const QRScannerScreen({required this.onVerified, super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканер QR-коду')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_isProcessing) return;

          final code = capture.barcodes.first.rawValue ?? '';
          try {
            final dynamic decoded = json.decode(code);
            if (decoded is Map<String, dynamic>) {
              final String? name = decoded['cred_name']?.toString().trim();
              final String? pass = decoded['cred_pass']?.toString().trim();

              if (name == 'sf' && pass == 'sf12345') {
                setState(() => _isProcessing = true);

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Успішно пройдено')),
                );

                widget.onVerified('$name:$pass');

                Future.delayed(const Duration(seconds: 1), () {
                  if (!mounted) return;
                  navigator.pop();
                });
              } else {
                _showError(context, 'Неправильні креденшали!');
              }
            } else {
              _showError(context, 'Невірний формат QR-коду!');
            }
          } catch (e) {
            _showError(context, 'Невірний формат QR-коду!');
          }
        },
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
