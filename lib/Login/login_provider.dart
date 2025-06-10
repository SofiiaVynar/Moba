import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Login/login_cubit.dart';

class LoginProvider {
  static final LoginCubit _instance = LoginCubit();

  static BlocProvider<LoginCubit> provide() {
    return BlocProvider<LoginCubit>.value(value: _instance);
  }

  static LoginCubit get instance => _instance;
}
