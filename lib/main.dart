import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Connectivity/connectivity_wrapper.dart';
import 'package:labb_1/Home/home.dart';
import 'package:labb_1/Login/login.dart';
import 'package:labb_1/Login/login_cubit.dart';
import 'package:labb_1/Page/page.dart';
import 'package:labb_1/Page/page_cubit.dart';
import 'package:labb_1/Profile/profile.dart';
import 'package:labb_1/Profile/profile_cubit.dart';
import 'package:labb_1/Register/register.dart';
import 'package:labb_1/Register/register_cubit.dart';
import 'package:labb_1/Sensors/sensors.dart';
import 'package:labb_1/Sensors/sensors_cubit.dart';
import 'package:labb_1/Set_up/setup_mcu.dart';
import 'package:labb_1/Set_up/setup_mcu_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(ElectricityApp(isLoggedIn: isLoggedIn));
}

class ElectricityApp extends StatelessWidget {
  final bool isLoggedIn;

  const ElectricityApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<RegistrationCubit>(create: (_) => RegistrationCubit()),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
        BlocProvider<EnergyCubit>(create: (_) => EnergyCubit()),
        BlocProvider<SensorCubit>(create: (_) => SensorCubit()),
        BlocProvider<SetupMicrocontrollerCubit>(
            create: (_) => SetupMicrocontrollerCubit(),),
      ],
      child: MaterialApp(
        title: 'Electricity App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFE7EEE4),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF9DB393),
          ),
        ),
        home: ConnectivityWrapper(
          child: isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
        routes: {
          '/login': (context) =>
          const ConnectivityWrapper(child: LoginScreen()),
          '/register': (context) =>
          const ConnectivityWrapper(child: RegistrationScreen()),
          '/profile': (context) =>
          const ConnectivityWrapper(child: ProfileScreen()),
          '/home': (context) =>
          const ConnectivityWrapper(child: HomeScreen()),
          '/page': (context) =>
              ConnectivityWrapper(child: EnergyTrackerScreen()),
          '/sensors': (context) =>
          const ConnectivityWrapper(child: SensorsScreen()),
          '/setup_mcu': (context) =>
          const ConnectivityWrapper(child: SetupMicrocontrollerScreen()),
        },
      ),
    );
  }
}
