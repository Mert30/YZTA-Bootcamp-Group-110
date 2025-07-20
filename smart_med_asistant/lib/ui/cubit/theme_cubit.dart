import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.light());

  void toggleTheme() {
    if (state.isDark) {
      emit(ThemeState.light());
    } else {
      emit(ThemeState.dark());
    }
  }
}
