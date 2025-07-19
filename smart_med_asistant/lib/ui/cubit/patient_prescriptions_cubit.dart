import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/entity/prescription.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';

part 'patient_prescriptions_state.dart';

class PatientPrescriptionsCubit extends Cubit<PatientPrescriptionsState> {
  final PrescriptionRepository _repository;

  PatientPrescriptionsCubit(this._repository) : super(PatientPrescriptionsInitial());

  Future<void> fetchPrescriptions() async {
    emit(PatientPrescriptionsLoading());

    try {
      final prescriptions = await _repository.getPrescriptionsForCurrentUser();
      emit(PatientPrescriptionsLoaded(prescriptions));
    } catch (e) {
      emit(PatientPrescriptionsError(e.toString()));
    }
  }
}
