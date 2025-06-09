import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    emit(ProfileLoaded(
      name: prefs.getString('user_name') ?? 'Невідомо',
      email: prefs.getString('user_email') ?? 'Невідомо',
      phone: prefs.getString('user_phone') ?? 'Невідомо',
      isEditing: false,
    ),);
  }

  Future<void> saveUserData(String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    emit(ProfileLoaded(
        name: name, email: email, phone: phone, isEditing: false,),);
  }

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(const ProfileDeleted());
  }

  void toggleEditing(ProfileLoaded current) {
    emit(current.copyWith(isEditing: !current.isEditing));
  }
}
