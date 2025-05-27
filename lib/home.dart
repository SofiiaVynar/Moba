import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _home(BuildContext context, String label, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A8E7F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          textStyle: const TextStyle(fontSize: 22,
            fontWeight: FontWeight.bold, ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна сторінка'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _home(context, 'Профіль', '/profile'),
                _home(context, 'Трекер електроенергії', '/page'),
                _home(context, 'Сенсори', '/sensors'),
                _home(context, 'Налаштувати МК', '/setup_mcu'),
                _home(context, 'Останні повідомлення МК', '/message'),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Image.network(
              'https://oswietlenieilampy.pl/wp-content/uploads/2020/06/O%C5%9Bwietlenie_elewacji_1592562636.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
