import 'package:flutter/material.dart';
import 'package:labb_1/home.dart';
import 'package:labb_1/login.dart';
import 'package:labb_1/page.dart';
import 'package:labb_1/profile.dart';
import 'package:labb_1/register.dart';
import 'package:labb_1/sensors.dart';
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
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/page': (context) => const EnergyTrackerScreen(),
        '/sensors': (context) => const SensorsScreen(),
      },
    );
  }
}
