part of 'qr_cubit.dart';

abstract class QrScanState {}

class QrScanInitial extends QrScanState {}

class QrScanSuccess extends QrScanState {
  final String result;
  QrScanSuccess(this.result);
}

class QrScanError extends QrScanState {
  final String message;
  QrScanError(this.message);
}
