import 'package:flutter/material.dart';
import 'package:labb_1/qr.dart';
import 'package:permission_handler/permission_handler.dart';

class SetupMicrocontrollerScreen extends StatefulWidget {
  const SetupMicrocontrollerScreen({super.key});

  @override
  State<SetupMicrocontrollerScreen> createState() => _SetupMicrocontrollerScreenState();
}

class _SetupMicrocontrollerScreenState extends State<SetupMicrocontrollerScreen> {
  String status = 'Очікування на підключення МК...';
  bool isConnectedToMCU = false;

  Future<void> _checkConnection() async {
    await Future.delayed(const Duration(seconds: 1)); // Симуляція
    setState(() {
      isConnectedToMCU = true; // true, якщо реально підключено
      status = isConnectedToMCU
          ? 'МК підключено. Відкриття сканера QR...'
          : 'МК не підключено!';
    });

    if (isConnectedToMCU) {
      await Future.delayed(const Duration(seconds: 1));
      _startQRScanner();
    }
  }

  void _startQRScanner() async {
    if (await Permission.camera.request().isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QRScannerScreen(
            onVerified: (data) {
              setState(() {
                status = 'Креденшали перевірено: $data';
              });
            },
          ),
        ),
      );
    } else {
      setState(() => status = 'Доступ до камери заборонено!');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування МК')),
      body: Center(child: Text(status, style: const TextStyle(fontSize: 18))),
    );
  }
}
