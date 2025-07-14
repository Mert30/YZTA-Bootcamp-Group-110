import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/repo/patient_repository.dart';

part 'patient_register_state.dart';

class PatientRegisterCubit extends Cubit<PatientRegisterState> {
  final PatientRepository repository;

  PatientRegisterCubit(this.repository) : super(PatientRegisterInitial());

  Future<void> register({
    required String fullname,
    required String email,
    required String password,
  }) async {
    emit(PatientRegisterLoading());
    try {
      await repository.register(fullname: fullname, email: email, password: password);
      emit(PatientRegisterSuccess());
    } catch (e) {
      emit(PatientRegisterFailure(error: e.toString()));
    }
  }
}
