// sensors_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Sensors/sensors_cubit.dart';
import 'package:labb_1/Sensors/sensors_state.dart';

class SensorsScreen extends StatelessWidget {
  const SensorsScreen({super.key});

  Widget _sensorCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.orangeAccent),
        title: Text(label, style: const TextStyle(fontSize: 20,
            fontWeight: FontWeight.bold,),),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SensorCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Сенсори електроенергії')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<SensorCubit, SensorState>(
            builder: (context, state) {
              return Column(
                children: [
                  _sensorCard('Напруга',
                      '${state.voltage.toStringAsFixed(2)} В', Icons.flash_on,),
                  _sensorCard('Потужність',
                    '${state.power.toStringAsFixed(2)} Вт',
                    Icons.electric_bolt,),
                  _sensorCard('Напруга з MQTT',
                      '${state.mqttVoltage} В', Icons.flash_on,),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
