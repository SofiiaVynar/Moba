import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Login/login.dart';
import 'package:labb_1/Login/login_cubit.dart';
import 'package:labb_1/Profile/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUserData(),
      child: _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileDeleted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (Route<dynamic> route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          nameController.text = state.name;
          emailController.text = state.email;
          phoneController.text = state.phone;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Профіль користувача'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Вийти',
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  context.read<ProfileCubit>().toggleEditing(state),
              tooltip: state.isEditing ? 'Скасувати' : 'Редагувати',
              child: Icon(state.isEditing ? Icons.close : Icons.edit),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 180, color: Colors.white),
                ),
                _profileTile('Ім\'я', state.name, nameController,
                    state.isEditing,),
                _profileTile('Email', state.email, emailController,
                    state.isEditing,),
                _profileTile('Телефон', state.phone, phoneController,
                    state.isEditing,),
                if (state.isEditing) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileCubit>().saveUserData(
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Зберегти'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Видалити акаунт'),
                    style: ElevatedButton.styleFrom(backgroundColor:
                    Colors.red,),
                  ),
                ],
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _profileTile(String title, String value,
      TextEditingController controller, bool isEditing,) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 25,
          fontWeight: FontWeight.bold,),),
      subtitle: isEditing
          ? TextField(controller: controller, decoration:
      InputDecoration(hintText: 'Введіть $title'),)
          : Text(value, style: const TextStyle(fontSize: 22)),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Видалення акаунту'),
        content: const Text('Ви впевнені? Цю дію не можна скасувати.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Скасувати'),),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Видалити'),),
        ],
      ),
    );

    if (confirm == true) {
      await cubit.deleteAccount();
    }
  }


  void _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Вихід'),
        content: const Text('Вийти з акаунту?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Скасувати'),),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Вийти'),),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => LoginCubit(),
            child: const LoginScreen(),
          ),
        ),
            (r) => false,
      );
    }
  }
}
