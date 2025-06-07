import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Sensors/sensors_state.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class SensorCubit extends Cubit<SensorState> {
  final Random _random = Random();
  late MqttServerClient _client;

  SensorCubit() : super(SensorState.initial()) {
    _updateSensorData();
    Timer.periodic(const Duration(seconds: 10), (_) => _updateSensorData());
    _connectToMQTT();
  }

  void _updateSensorData() {
    final voltage = 210 + _random.nextDouble() * 30;
    final power = 100 + _random.nextDouble() * 900;
    emit(state.copyWith(voltage: voltage, power: power));
  }

  Future<void> _connectToMQTT() async {
    _client = MqttServerClient('test.mosquitto.org', 'client_1')
      ..port = 1883
      ..logging(on: true)
      ..keepAlivePeriod = 20
      ..onDisconnected = _onDisconnected
      ..onConnected = _onConnected;

    try {
      await _client.connect();
    } catch (_) {
      _client.disconnect();
    }
  }

  void _onConnected() {
    _client.subscribe('sensor/voltage', MqttQos.atMostOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      emit(state.copyWith(mqttVoltage: payload));
    });
  }

  void _onDisconnected() {
  }

  @override
  Future<void> close() {
    _client.disconnect();
    return super.close();
  }
}
