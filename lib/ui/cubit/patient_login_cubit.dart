import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/repo/patient_repository.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends Cubit<PatientLoginState> {
  final PatientRepository repository;

  PatientLoginCubit(this.repository) : super(PatientLoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(PatientLoginLoading());
    try {
      await repository.login(email: email, password: password);
      emit(PatientLoginSuccess());
    } catch (e) {
      emit(PatientLoginFailure(error: e.toString()));
    }
  }
}
