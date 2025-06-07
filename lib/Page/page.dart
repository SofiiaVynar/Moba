import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Page/page_cubit.dart';

class EnergyTrackerScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EnergyTrackerScreen({super.key});

  void _handleInput(BuildContext context) {
    final input = _controller.text;
    final cubit = context.read<EnergyCubit>();

    if (input == 'LOE') {
      cubit.reset();
      _showMessage(context, 'Показники скинуто.');
    } else {
      final number = int.tryParse(input);
      if (number != null) {
        cubit.addUsage(number);
      } else {
        _showMessage(context, 'Будь ласка, введіть число або анулюйте.');
      }
    }
    _controller.clear();
  }

  void _showMessage(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Повідомлення'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Трекер електроенергії')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            BlocBuilder<EnergyCubit, int>(
              builder: (context, state) {
                return Text(
                  'Використано електроенергії: $state',
                  style: const TextStyle(fontSize: 32),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius:
                BorderRadius.circular(15),),
                labelText: 'Введіть число або анулюйте',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => _handleInput(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60),
                textStyle: const TextStyle(fontSize: 20),
                padding: const EdgeInsets.symmetric(vertical: 15,
                    horizontal: 30,),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Змінити показники'),
            ),
            const SizedBox(height: 20),
            Image.network(
              'https://dl-media.viber.com/1/share/2/long/vibes/icon/image/0x0/e318/5085d393ce2f77c9f73cb1b8ae46f653472bae3f16aff867406289e9dc78e318.jpg',
              height: 480,
            ),
          ],
        ),
      ),
    );
  }
}
