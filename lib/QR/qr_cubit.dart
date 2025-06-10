import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'qr_state.dart';

class QrScanCubit extends Cubit<QrScanState> {
  QrScanCubit() : super(QrScanInitial());

  void verifyCode(String rawCode) {
    try {
      final dynamic decoded = json.decode(rawCode);
      if (decoded is! Map<String, dynamic>) {
        emit(QrScanError('Невірний формат QR-коду!'));
        return;
      }

      final name = decoded['cred_name']?.toString().trim();
      final pass = decoded['cred_pass']?.toString().trim();

      if (name == 'sf' && pass == 'sf12345') {
        emit(QrScanSuccess('$name:$pass'));
      } else {
        emit(QrScanError('Неправильні креденшали!'));
      }
    } catch (_) {
      emit(QrScanError('Невірний формат QR-коду!'));
    }
  }
}
