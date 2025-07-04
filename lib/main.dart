import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(              // MaterialApp en dışta olmalı
      debugShowCheckedModeBanner: false,
      home: DeviceFrame(             // DeviceFrame MaterialApp içinde
        device: Devices.android.mediumPhone,
        screen: LoginPage(),
      ),
    );
  }
}
