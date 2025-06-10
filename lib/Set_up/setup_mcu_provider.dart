import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Set_up/setup_mcu_cubit.dart';

class SetupMicrocontrollerProvider {
  static final SetupMicrocontrollerCubit _instance =
      SetupMicrocontrollerCubit();

  static BlocProvider<SetupMicrocontrollerCubit> provide() {
    return BlocProvider<SetupMicrocontrollerCubit>.value(value: _instance);
  }

  static SetupMicrocontrollerCubit get instance => _instance;
}
