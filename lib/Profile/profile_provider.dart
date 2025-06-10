import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Profile/profile_cubit.dart';

class ProfileProvider {
  static final ProfileCubit _instance = ProfileCubit();

  static BlocProvider<ProfileCubit> provide() {
    return BlocProvider<ProfileCubit>.value(value: _instance);
  }

  static ProfileCubit get instance => _instance;
}
