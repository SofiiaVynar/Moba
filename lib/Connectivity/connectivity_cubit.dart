import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityCubit extends Cubit<bool> {
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityCubit() : super(true) {
    _init();
  }

  void _init() async {
    final result = await Connectivity().checkConnectivity();
    emit(result != ConnectivityResult.none);

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      emit(result != ConnectivityResult.none);
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
