import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Register/register_cubit.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  static final _formKey = GlobalKey<FormState>();
  static final _nameController = TextEditingController();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _phoneNumberController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Заповніть ім\'я';
    if (RegExp(r'\d').hasMatch(value)) return 'Ім\'я не може містити цифр';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Заповніть електронну пошту';
    if (!value.contains('@')) {
      return 'Електронна пошта повинна містити символ "@"';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Заповніть пароль';
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Заповніть номер телефону';
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value))
      return 'Невірний формат номера телефону';
    return null;
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegistrationCubit>().registerUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phone: _phoneNumberController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Зареєстровано')),
          );
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _phoneNumberController.clear();
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is RegistrationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Реєстрація')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Ім\'я'),
                  validator: _validateName,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: 'Електронна пошта'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Номер телефону'),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNumber,
                ),
                const SizedBox(height: 20),
                BlocBuilder<RegistrationCubit, RegistrationState>(
                  builder: (context, state) {
                    if (state is RegistrationLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: const Text('Зареєструватися'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
