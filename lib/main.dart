import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:eye_see_codes/local_storage.dart';
import 'package:flutter/material.dart';

import 'notification_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationScreen(),
    );
  }
}

