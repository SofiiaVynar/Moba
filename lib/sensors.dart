import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  SensorsScreenState createState() => SensorsScreenState();
}

class SensorsScreenState extends State<SensorsScreen> {
  final Random _random = Random();
  double _voltage = 0;
  double _power = 0;
  String _voltageFromMqtt = '--';

  late MqttServerClient _client;

  @override
  void initState() {
    super.initState();
    _updateSensorData();
    Timer.periodic(const Duration(seconds: 10), (timer) => _updateSensorData());
    _connectToMQTT();
  }

  void _updateSensorData() {
    setState(() {
      _voltage = 210 + _random.nextDouble() * 30;
      _power = 100 + _random.nextDouble() * 900;
    });
  }

  Future<void> _connectToMQTT() async {
    _client = MqttServerClient('test.mosquitto.org', 'client_1');
    _client.port = 1883;
    _client.logging(on: true);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;

    try {
      await _client.connect();
    } catch (e) {
      if (kDebugMode) {
        print('MQTT connection failed: $e');
      }
      _client.disconnect();
    }
  }


  void _onConnected() {
    if (kDebugMode) {
      print('MQTT Connected');
    }
    _client.subscribe('sensor/voltage', MqttQos.atMostOnce);

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString
        (recMess.payload.message);

      setState(() {
        _voltageFromMqtt = payload;
      });
    });
  }

  void _onDisconnected() {
    if (kDebugMode) {
      print('MQTT Disconnected');
    }
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
            _sensorCard('Напруга',
                '${_voltage.toStringAsFixed(2)} В',
                Icons.flash_on,),
            _sensorCard('Потужність',
                '${_power.toStringAsFixed(2)} Вт',
                Icons.electric_bolt,),
            _sensorCard('Напруга з MQTT',
                '$_voltageFromMqtt В',
                Icons.flash_on,),
          ],
        ),
      ),
    );
  }
}
