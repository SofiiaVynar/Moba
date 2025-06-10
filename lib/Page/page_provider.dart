import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labb_1/Page/page_cubit.dart';

class EnergyProvider {
  static final EnergyCubit _instance = EnergyCubit();

  static BlocProvider<EnergyCubit> provide() {
    return BlocProvider<EnergyCubit>.value(value: _instance);
  }

  static EnergyCubit get instance => _instance;
}
