import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Connectivity/connectivity_cubit.dart';

class ConnectivityProvider {
  static final ConnectivityCubit _instance = ConnectivityCubit();

  static BlocProvider<ConnectivityCubit> provide() {
    return BlocProvider<ConnectivityCubit>.value(value: _instance);
  }

  static ConnectivityCubit get instance => _instance;
}
