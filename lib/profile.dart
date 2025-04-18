import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  String _phoneNumber = '';

  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? 'Невідомо';
      _email = prefs.getString('user_email') ?? 'Невідомо';
      _phoneNumber = prefs.getString('user_phone') ?? 'Невідомо';

      _nameController.text = _name;
      _emailController.text = _email;
      _phoneController.text = _phoneNumber;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_phone', _phoneController.text);

    setState(() {
      _isEditing = false;
      _name = _nameController.text;
      _email = _emailController.text;
      _phoneNumber = _phoneController.text;
    });
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Видалення акаунту'),
        content: const Text('Ви впевнені, що хочете видалити акаунт? '
            'Цю дію не можна скасувати.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Видалити', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteAccount();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Widget _profile(String title, String value,
      TextEditingController controller,) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      subtitle: _isEditing
          ? TextField(
        controller: controller,
        style: const TextStyle(fontSize: 22),
        decoration: InputDecoration(
          hintText: 'Введіть $title',
        ),
      )
          : Text(
        value,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Вийти',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isEditing = !_isEditing;
          });
        },
        tooltip: _isEditing ? 'Скасувати редагування' : 'Редагувати',
        child: Icon(_isEditing ? Icons.close : Icons.edit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 100,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, size: 180, color: Colors.white),
          ),
          const SizedBox(height: 20),
          _profile('Ім\'я', _name, _nameController),
          _profile('Електронна пошта', _email, _emailController),
          _profile('Телефон', _phoneNumber, _phoneController),
          if (_isEditing) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveUserData,
              icon: const Icon(Icons.save),
              label: const Text('Зберегти'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _confirmDeleteAccount,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Видалити акаунт'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
