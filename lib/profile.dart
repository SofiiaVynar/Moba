import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _profile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      subtitle: Text(
          value,
        style: const TextStyle(fontSize: 22),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 100,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, size: 180, color: Colors.white,),),
          _profile('Ім\'я', 'Софія'),
          _profile('Електронна пошта', 'sofia@gmail.com'),
          _profile('Телефон', '+38012345678'),
        ],
      ),
    );
  }
}
