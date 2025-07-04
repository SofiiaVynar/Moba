import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Connectivity/connectivity_cubit.dart';
import 'package:labb_1/Connectivity/connectivity_provider.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, bool>(
      bloc: ConnectivityProvider.instance,
      listenWhen: (previous, current) => previous != current,
      listener: (context, isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isConnected
                  ? 'Відновлено з’єднання з Інтернетом'
                  : 'Втрачено з’єднання з Інтернетом',
            ),
            duration: const Duration(seconds: 7),
          ),
        );
      },
      child: child,
    );
  }
}
