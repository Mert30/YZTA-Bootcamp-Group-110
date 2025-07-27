import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Timezone verilerini başlat
    tz.initializeTimeZones();
    
    // Türkiye saat dilimini ayarla
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));

    // Android 13+ için bildirim izni iste
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          print('Bildirim izni verilmedi');
          return;
        }
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Bildirime tıklandığında yapılacak işlemler
        print('Bildirime tıklandı: ${response.payload}');
      },
    );

    // Android için bildirim kanalı oluştur
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  static Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel medicineChannel = AndroidNotificationChannel(
      'daily_medicine_channel_id',
      'İlaç Hatırlatıcı',
      description: 'Günlük ilaç hatırlatıcı bildirimi',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel testChannel = AndroidNotificationChannel(
      'test_channel_id',
      'Test Bildirimi',
      description: 'Tek seferlik test bildirimi',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(medicineChannel);
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(testChannel);
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
    print('Tüm bildirimler iptal edildi');
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print('Bildirim iptal edildi: $id');
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    try {
      final now = tz.TZDateTime.now(tz.local);
      
      // Bugün için zamanlanmış saat
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // Eğer saat geçmişse, yarın için planla
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_medicine_channel_id',
            'İlaç Hatırlatıcı',
            channelDescription: 'Günlük ilaç hatırlatıcı bildirimi',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Her gün tekrarla
      );

      print('Günlük bildirim zamanlandı - ID: $id, Saat: ${time.hour}:${time.minute}');
    } catch (e) {
      print('Günlük bildirim zamanlama hatası: $e');
    }
  }

  static Future<void> scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
      
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel_id',
            'Test Bildirimi',
            channelDescription: 'Tek seferlik test bildirimi',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      print('Tek seferlik bildirim zamanlandı - ID: $id, Tarih: $scheduledDate');
    } catch (e) {
      print('Tek seferlik bildirim zamanlama hatası: $e');
    }
  }

  // Zamanlanan bildirimleri listele (debug için)
  static Future<void> listScheduledNotifications() async {
    final pendingNotifications = await _notificationsPlugin.pendingNotificationRequests();
    print('Bekleyen bildirimler: ${pendingNotifications.length}');
    for (final notification in pendingNotifications) {
      print('ID: ${notification.id}, Başlık: ${notification.title}');
    }
  }

  // Test bildirimi gönder
  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await _notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel_id',
          'Test Bildirimi',
          channelDescription: 'Anlık test bildirimi',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}