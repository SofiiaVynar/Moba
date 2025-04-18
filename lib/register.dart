import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ім\'я не може бути порожнім';
    }
    if (RegExp(r'\d').hasMatch(value)) {
      return 'Ім\'я не може містити цифр';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Електронна пошта не може бути порожньою';
    }
    if (!value.contains('@')) {
      return 'Електронна пошта повинна містити символ "@"';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль не може бути порожнім';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Номер телефону не може бути порожнім';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Невірний формат номера телефону';
    }
    return null;
  }

  Future<void> _saveUserData(String name, String email,
      String password, String phoneNumber,) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_password', password);
    await prefs.setString('user_phone', phoneNumber);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await _saveUserData(_name, _email, _password, _phoneNumber);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дані успішно надіслані')),
      );

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneNumberController.clear();

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ім\'я'),
                onSaved: (value) => _name = value!,
                validator: _validateName,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText:
                'Електронна пошта',),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                onSaved: (value) => _password = value!,
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Номер телефону'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value!,
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
