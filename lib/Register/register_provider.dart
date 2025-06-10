import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Register/register_cubit.dart';

class RegistrationProvider {
  static final RegistrationCubit _instance = RegistrationCubit();

  static BlocProvider<RegistrationCubit> provide() {
    return BlocProvider<RegistrationCubit>.value(value: _instance);
  }

  static RegistrationCubit get instance => _instance;
}
