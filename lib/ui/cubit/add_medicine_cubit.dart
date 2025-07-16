import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/prescription_repository.dart';
import '../../../data/entity/prescription.dart';
import '../../../data/service/gemini_service.dart';

part 'add_medicine_state.dart';

class AddMedicineCubit extends Cubit<AddMedicineState> {
  final PrescriptionRepository _repo;
  final GeminiService _geminiService;

  AddMedicineCubit(this._repo, this._geminiService) : super(AddMedicineInitial());

  // 🧠 Yapay Zeka ile İlaç Bilgisi Getirme
  Future<void> fetchMedicineInfoFromAI(String barcode) async {
    emit(AddMedicineLoading());

    try {
      final ilacMap = await _geminiService.loadIlacMap();
      final ilac = ilacMap[barcode];

      if (ilac == null) {
        emit(AddMedicineFailure(message: "İlaç verisi bulunamadı."));
        return;
      }

      final summary = await _geminiService.fetchGeminiSummary(ilac);
      emit(AddMedicineAIResponse(summary));
    } catch (e) {
      emit(AddMedicineFailure(message: "AI verisi alınamadı: ${e.toString()}"));
    }
  }

  Future<void> saveMedicine({
    required String barcode,
    required String patientEmail,
    required DateTime startDate,
    required DateTime finishDate,
  }) async {
    emit(AddMedicineLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 📥 JSON’dan ilaç bilgisini al
      final ilacMap = await _geminiService.loadIlacMap();
      final ilac = ilacMap[barcode];

      if (ilac == null) {
        throw Exception('İlaç verisi bulunamadı.');
      }

      // 🧠 Gemini AI’dan cevap al
      final geminiResponse = await _geminiService.fetchGeminiSummary(ilac);
      final parsedAI = _geminiService.parseGeminiResponse(geminiResponse);

      // 📝 Reçeteyi oluştur
      final prescription = Prescription(
        barcode: barcode,
        startDate: startDate,
        finishDate: finishDate,
        addedBy: uid,
        id: '',
        descriptionAI: parsedAI['descriptionAI'],
        usageAI: parsedAI['usageAI'],
        sideEffectsAI: parsedAI['sideEffectsAI'],
      );

      // 💾 Firestore'a kaydet
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
