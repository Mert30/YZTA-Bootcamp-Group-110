import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../data/repo/prescription_repository.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final PrescriptionRepository _repo;

  PatientsCubit(this._repo) : super(PatientsInitial());

  Future<void> fetchPatients() async {
    emit(PatientsLoading());
    try {
      final patients = await _repo.getPatientsAddedByPharmacist();
      emit(PatientsLoaded(patients));
    } catch (e) {
      emit(PatientsError(e.toString()));
    }
  }
}
