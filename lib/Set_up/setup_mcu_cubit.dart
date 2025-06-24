import 'package:flutter_bloc/flutter_bloc.dart';

class SetupMicrocontrollerState {
  final String status;
  final bool isConnected;

  SetupMicrocontrollerState({
    required this.status,
    required this.isConnected,
  });

  SetupMicrocontrollerState copyWith({
    String? status,
    bool? isConnected,
  }) {
    return SetupMicrocontrollerState(
      status: status ?? this.status,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class SetupMicrocontrollerCubit extends Cubit<SetupMicrocontrollerState> {
  SetupMicrocontrollerCubit()
      : super(
          SetupMicrocontrollerState(
            status: 'Очікування на підключення МК...',
            isConnected: false,
          ),
        ) {
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        isConnected: true,
        status: 'МК підключено. Відкриття сканера QR...',
      ),
    );
  }

  void updateStatus(String newStatus) {
    emit(state.copyWith(status: newStatus));
  }
}
