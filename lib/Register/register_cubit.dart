import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'register_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegistrationLoading());
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phone);

      await _secureStorage.write(key: 'user_password', value: password);

      emit(RegistrationSuccess());
    } catch (e) {
      emit(RegistrationError('Помилка збереження: ${e.toString()}'));
    }
  }

  Future<String?> getStoredPassword() async {
    return await _secureStorage.read(key: 'user_password');
  }

  Future<void> clearSecureData() async {
    await _secureStorage.delete(key: 'user_password');
  }
}
