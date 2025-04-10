import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  SensorsScreenState createState() => SensorsScreenState();
}

class SensorsScreenState extends State<SensorsScreen> {
  final Random _random = Random();
  double _voltage = 0;
  double _power = 0;

  @override
  void initState() {
    super.initState();
    _updateSensorData();
    Timer.periodic(const Duration(seconds: 10), (timer) => _updateSensorData());
  }

  void _updateSensorData() {
    setState(() {
      _voltage = 210 + _random.nextDouble() * 30;
      _power = 100 + _random.nextDouble() * 900;
    });
  }

  Widget _sensorCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.orangeAccent),
        title: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сенсори електроенергії')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _sensorCard('Напруга', '${_voltage.toStringAsFixed(2)} В',
                Icons.flash_on),
            _sensorCard('Потужність', '${_power.toStringAsFixed(2)} Вт',
                Icons.electric_bolt),
          ],
        ),
      ),
    );
  }
}
