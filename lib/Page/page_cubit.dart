import 'package:flutter_bloc/flutter_bloc.dart';

class EnergyCubit extends Cubit<int> {
  EnergyCubit() : super(0);

  void reset() => emit(0);

  void addUsage(int amount) => emit(state + amount);
}
