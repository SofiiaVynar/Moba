import 'package:flutter/material.dart';
import 'package:labb_1/home.dart';
import 'package:labb_1/login.dart';
import 'package:labb_1/page.dart';
import 'package:labb_1/profile.dart';
import 'package:labb_1/register.dart';

void main() {
  runApp(const ElectricityApp());
}

class ElectricityApp extends StatelessWidget {
  const ElectricityApp({super.key});

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
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/page': (context) => const EnergyTrackerScreen(),
      },
    );
  }
}
