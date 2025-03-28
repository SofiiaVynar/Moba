import 'package:flutter/material.dart';

class Electricity extends StatelessWidget {
  const Electricity({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnergyTrackerScreen(),
    );
  }
}

class EnergyTrackerScreen extends StatefulWidget {
  const EnergyTrackerScreen({super.key});

  @override
  EnergyTrackerScreenState createState() => EnergyTrackerScreenState();
}

class EnergyTrackerScreenState extends State<EnergyTrackerScreen> {
  int _energyUsage = 0;
  final TextEditingController _energyInputController = TextEditingController();

  void _updateEnergyUsage() {
    final String input = _energyInputController.text;
    if (input == 'LOE') {
      setState(() {
        _energyUsage = 0;
      });
      _message('Показники скинуто.');
    } else {
      final int? number = int.tryParse(input);
      if (number != null) {
        setState(() {
          _energyUsage += number;
        });
      } else {
        _message('Будь ласка, введіть число або анулюйте.');
      }
    }
    _energyInputController.clear();
  }

  void _message(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Повідомлення'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер електроенергії'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Використано електроенергії: $_energyUsage',
              style: const TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _energyInputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: 'Введіть число або анулюйте',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _updateEnergyUsage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 20),
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Змінити показники'),
            ),
            Image.network('https://dl-media.viber.com/1/share/2/long/vibes/icon/image/0x0/e318/5085d393ce2f77c9f73cb1b8ae46f653472bae3f16aff867406289e9dc78e318.jpg',
              height: 482,
            ),
          ],
        ),
      ),
    );
  }
}
