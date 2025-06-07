import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('user_password');

    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (storedEmail == email && storedPassword == password) {
      await prefs.setBool('is_logged_in', true);
      emit(LoginSuccess());
    } else {
      emit(LoginError('Невірний email або пароль'));
    }
  }
}
