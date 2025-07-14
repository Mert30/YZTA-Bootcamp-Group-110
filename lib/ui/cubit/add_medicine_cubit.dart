import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/prescription_repository.dart';
import '../../../data/entity/prescription.dart';

part 'add_medicine_state.dart';

class AddMedicineCubit extends Cubit<AddMedicineState> {
  final PrescriptionRepository _repo;

  AddMedicineCubit(this._repo) : super(AddMedicineInitial());

  Future<void> saveMedicine({
    required String barcode,
    required String patientEmail,
    required DateTime startDate,
    required DateTime finishDate,
  }) async {
    emit(AddMedicineLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final prescription = Prescription(
        barcode: barcode,
        startDate: startDate,
        finishDate: finishDate,
        addedBy: uid, id: '',
      );

      await _repo.addPrescription(
        prescription: prescription,
        patientEmail: patientEmail,
      );

      emit(AddMedicineSuccess());
    } catch (e) {
      emit(AddMedicineFailure(message: e.toString()));
    }
  }
}
