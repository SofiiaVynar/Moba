import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Profile/profile.dart';
import 'package:labb_1/Profile/profile_cubit.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserData(),
      child: const ProfileView(),
    );
  }
}
