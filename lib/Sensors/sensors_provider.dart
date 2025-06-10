import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Sensors/sensors_cubit.dart';

class SensorProvider {
  static final SensorCubit _instance = SensorCubit();

  static BlocProvider<SensorCubit> provide() {
    return BlocProvider<SensorCubit>.value(value: _instance);
  }

  static SensorCubit get instance => _instance;
}
