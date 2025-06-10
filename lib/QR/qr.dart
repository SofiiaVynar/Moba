import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/QR/qr_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  final void Function(String) onVerified;

  const QRScannerScreen({required this.onVerified, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrScanCubit(),
      child: _QRScannerView(onVerified: onVerified),
    );
  }
}

class _QRScannerView extends StatelessWidget {
  final void Function(String) onVerified;

  const _QRScannerView({required this.onVerified});

  @override
  Widget build(BuildContext context) {
    final controller = MobileScannerController();

    return Scaffold(
      appBar: AppBar(title: const Text('Сканер QR-коду')),
      body: BlocConsumer<QrScanCubit, QrScanState>(
        listener: (context, state) {
          if (state is QrScanSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Успішно пройдено')),
            );

            Navigator.of(context).pop();
            onVerified(state.result);
          }
        },
        builder: (context, state) {
          return MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final code = capture.barcodes.first.rawValue ?? '';
              context.read<QrScanCubit>().verifyCode(code);
            },
          );
        },
      ),
    );
  }
}
