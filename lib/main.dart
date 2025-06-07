import 'package:flutter/material.dart';
import 'package:labb_1/connectivity_wrapper.dart';
import 'package:labb_1/home.dart';
import 'package:labb_1/login.dart';
import 'package:labb_1/page.dart';
import 'package:labb_1/profile.dart';
import 'package:labb_1/register.dart';
import 'package:labb_1/sensors.dart';
import 'package:labb_1/setup_mcu.dart';
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
    return MaterialApp(
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
        '/login': (context) => const ConnectivityWrapper(child: LoginScreen()),
        '/register': (context) => const ConnectivityWrapper(child: RegistrationScreen()),
        '/profile': (context) => const ConnectivityWrapper(child: ProfileScreen()),
        '/home': (context) => const ConnectivityWrapper(child: HomeScreen()),
        '/page': (context) => const ConnectivityWrapper(child: EnergyTrackerScreen()),
        '/sensors': (context) => const ConnectivityWrapper(child: SensorsScreen()),
        '/setup_mcu': (context) => const ConnectivityWrapper(child: SetupMicrocontrollerScreen()),
      },
    );
  }
}
