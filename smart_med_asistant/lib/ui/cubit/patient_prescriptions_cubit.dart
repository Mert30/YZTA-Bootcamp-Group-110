import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_med_assistant/data/entity/prescription.dart';
import 'package:smart_med_assistant/data/repo/prescription_repository.dart';
import 'package:smart_med_assistant/data/service/notification_service.dart';
import 'package:smart_med_assistant/data/service/gemini_service.dart';

part 'patient_prescriptions_state.dart';

class PatientPrescriptionsCubit extends Cubit<PatientPrescriptionsState> {
  final PrescriptionRepository _repository;

  PatientPrescriptionsCubit(this._repository)
    : super(PatientPrescriptionsInitial());

  Future<void> fetchPrescriptions() async {
    emit(PatientPrescriptionsLoading());

    try {
      final prescriptions = await _repository.getPrescriptionsForCurrentUser();
      emit(PatientPrescriptionsLoaded(prescriptions));

      // Bildirimleri planla
      await _planNotificationsFromPrescriptions(prescriptions);

      // Gemini ile etkileşim analizi
      final barcodes = prescriptions.map((e) => e.barcode).where((e) => e.isNotEmpty).toList();

      if (barcodes.length >= 2) {
        final geminiService = GeminiService("AIzaSyCogncljqhDbk53iFWtLvfXGmoKOCmUnuE");
        geminiService.startChatSession();

        final result = await geminiService.analyzeDrugInteractions(barcodes);

        // Yeni state emit et (aynı reçeteler + etkileşim sonucu)
        emit(PatientPrescriptionsLoaded(prescriptions, interactionAnalysis: result));
      }

      // Test bildirimi (geliştirme aşamasında kullanın)
      //await _scheduleTestNotification();
    } catch (e) {
      emit(PatientPrescriptionsError(e.toString()));
    }
  }

  Future<void> _scheduleTestNotification() async {
    try {
      await NotificationService.scheduleOneTimeNotification(
        id: 99999, // Test için sabit ID
        title: 'Test Bildirimi',
        body: 'Bu bir test bildirimidir. 10 saniye sonra gösterilecek.',
        scheduledDate: DateTime.now().add(const Duration(seconds: 10)),
        payload: 'test_notification',
      );
      print('Test bildirimi 10 saniye sonra için zamanlandı');
    } catch (e) {
      print('Test bildirimi zamanlama hatası: $e');
    }
  }

  Future<void> _planNotificationsFromPrescriptions(
    List<Prescription> prescriptions,
  ) async {
    try {
      // Önceki bildirimleri temizle
      await NotificationService.cancelAll();

      int notificationId = 1000; // Başlangıç ID'si
      final now = DateTime.now();
      int scheduledCount = 0;

      print(
        'Bildirim planlama başladı. Toplam reçete: ${prescriptions.length}',
      );

      for (final prescription in prescriptions) {
        // Reçete tarih aralığını kontrol et
        if (now.isBefore(prescription.startDate)) {
          print('Reçete henüz başlamamış: ${prescription.barcode}');
          continue;
        }

        if (now.isAfter(prescription.finishDate)) {
          print('Reçete süresi dolmuş: ${prescription.barcode}');
          continue;
        }

        print('Aktif reçete işleniyor: ${prescription.barcode}');

        // Zaman etiketlerini ayır ve temizle
        final timeLabels = prescription.selectedTime
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        print('Zaman etiketleri: $timeLabels');

        for (final timeLabel in timeLabels) {
          final timeOfDay = _parseTimeLabel(timeLabel);

          if (timeOfDay != null) {
            await NotificationService.scheduleDailyNotification(
              id: notificationId++,
              title: 'İlaç Hatırlatma 💊',
              body: '${prescription.barcode} ilacını alma zamanınız geldi!',
              time: timeOfDay,
              payload: 'medicine_${prescription.barcode}_$timeLabel',
            );
            scheduledCount++;
            print(
              'Bildirim zamanlandı: ${prescription.barcode} - $timeLabel (${timeOfDay.hour}:${timeOfDay.minute})',
            );
          } else {
            print('Tanınmayan zaman etiketi: $timeLabel');
          }
        }
      }

      print('Toplam $scheduledCount bildirim zamanlandı');

      // Debug için zamanlanmış bildirimleri listele
      await NotificationService.listScheduledNotifications();
    } catch (e) {
      print('Bildirim planlama hatası: $e');
    }
  }

  TimeOfDay? _parseTimeLabel(String timeLabel) {
    final cleanLabel = timeLabel.toLowerCase().trim();

    switch (cleanLabel) {
      case 'sabah':
        return const TimeOfDay(hour: 8, minute: 0); // Sabah 08:00
      case 'öğle':
        return const TimeOfDay(hour: 13, minute: 15); // Öğle 13:15
      case 'akşam':
        return const TimeOfDay(hour: 19, minute: 0); // Akşam 19:00
      default:
        // Özel saat formatı kontrolü (örn: "14:30")
        final timePattern = RegExp(r'^(\d{1,2}):(\d{2})$');
        final match = timePattern.firstMatch(cleanLabel);
        if (match != null) {
          final hour = int.tryParse(match.group(1)!);
          final minute = int.tryParse(match.group(2)!);
          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour <= 23 &&
              minute >= 0 &&
              minute <= 59) {
            return TimeOfDay(hour: hour, minute: minute);
          }
        }
        return null;
    }
  }

  // Manuel olarak bildirimleri yeniden planla
  Future<void> rescheduleNotifications() async {
    if (state is PatientPrescriptionsLoaded) {
      final prescriptions = (state as PatientPrescriptionsLoaded).prescriptions;
      await _planNotificationsFromPrescriptions(prescriptions);
    }
  }

  // Tüm bildirimleri iptal et
  Future<void> cancelAllNotifications() async {
    await NotificationService.cancelAll();
    print('Tüm bildirimler iptal edildi');
  }

  // Test bildirimi gönder (anında)
  Future<void> sendTestNotification() async {
    await NotificationService.showInstantNotification(
      title: 'Anlık Test Bildirimi',
      body: 'Bu bildirim hemen gösterildi!',
    );
  }

  Future<String> analyzeDrugInteractionsWithGemini(GeminiService geminiService) async {
    if (state is! PatientPrescriptionsLoaded) {
      return "Reçeteler yüklenmedi. Lütfen tekrar deneyin.";
    }

    final prescriptions = (state as PatientPrescriptionsLoaded).prescriptions;

    final barcodes = prescriptions
        .map((e) => e.barcode)
        .where((barcode) => barcode.isNotEmpty)
        .toList();

    if (barcodes.length < 2) {
      return "Etkileşim analizi için en az iki ilaç gerekli.";
    }

    return await geminiService.analyzeDrugInteractions(barcodes);
  }

}
