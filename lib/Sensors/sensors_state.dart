class SensorState {
  final double voltage;
  final double power;
  final String mqttVoltage;

  const SensorState({
    required this.voltage,
    required this.power,
    required this.mqttVoltage,
  });

  SensorState copyWith({
    double? voltage,
    double? power,
    String? mqttVoltage,
  }) {
    return SensorState(
      voltage: voltage ?? this.voltage,
      power: power ?? this.power,
      mqttVoltage: mqttVoltage ?? this.mqttVoltage,
    );
  }

  factory SensorState.initial() => const SensorState(
    voltage: 0,
    power: 0,
    mqttVoltage: '--',
  );
}
