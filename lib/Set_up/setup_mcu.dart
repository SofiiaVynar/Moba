import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/QR/qr.dart';
import 'package:labb_1/Set_up/setup_mcu_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class SetupMicrocontrollerScreen extends StatelessWidget {
  const SetupMicrocontrollerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetupMicrocontrollerCubit(),
      child: const SetupMicrocontrollerView(),
    );
  }
}

class SetupMicrocontrollerView extends StatefulWidget {
  const SetupMicrocontrollerView({super.key});

  @override
  State<SetupMicrocontrollerView> createState() =>
      _SetupMicrocontrollerViewState();
}

class _SetupMicrocontrollerViewState extends State<SetupMicrocontrollerView> {
  late final SetupMicrocontrollerCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SetupMicrocontrollerCubit>();

    cubit.stream.listen((state) {
      if (state.isConnected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _startQRScanner();
        });
      }
    });
  }

  void _startQRScanner() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => QRScannerScreen(
            onVerified: (data) {
              if (!mounted) return;
              cubit.updateStatus('Креденшали перевірено: $data');
            },
          ),
        ),
      );
    } else {
      cubit.updateStatus('Доступ до камери заборонено!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Налаштування МК')),
      body: BlocBuilder<SetupMicrocontrollerCubit, SetupMicrocontrollerState>(
        builder: (context, state) {
          return Center(
            child: Text(state.status, style: const TextStyle(fontSize: 18)),
          );
        },
      ),
    );
  }
}
