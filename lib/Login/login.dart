import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Login/login_cubit.dart';
import 'package:labb_1/Login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final Connectivity _connectivity;
  late final StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Немає інтернету')),
        );
      }
    });
    _checkAutoLogin();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _tryLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введіть коректний email')),
      );
      return;
    }

    if (password.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:
        Text('Пароль повинен містити мінімум 6 символів'),),
      );
      return;
    }

    context.read<LoginCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Логін')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _loginField('Електронна пошта', _emailController),
                _loginField('Пароль', _passwordController, obscure: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is LoginLoading ? null : _tryLogin,
                  child: state is LoginLoading
                      ? const CircularProgressIndicator()
                      : const Text('Увійти', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Не маєте акаунту? Реєстрація',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _loginField(String label, TextEditingController controller,
      {bool obscure = false,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
