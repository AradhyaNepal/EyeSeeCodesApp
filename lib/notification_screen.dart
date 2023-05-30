import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  final Completer<NotificationData> _notificationInitialized = Completer();

  void initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.max,
            enableLights: true,
            enableVibration: true,
            colorized: true,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    _notificationInitialized.complete(
      NotificationData(
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        notificationDetails: notificationDetails,
      ),
    );
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    final bool timerStarted = timer != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notify Eye Rest"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (timerStarted) {
                timer?.cancel();
                timer = null;
              } else {
                timer =
                    Timer.periodic(const Duration(seconds: 10), (timer) async {
                  if (await Vibration.hasVibrator() == true) {
                    Vibration.vibrate(duration: 5000, amplitude: 255);
                  }
                  final data=await _notificationInitialized.future;
                  await data.flutterLocalNotificationsPlugin.show(timer.tick,
                      'plain title', 'plain body', data.notificationDetails,
                      payload: 'item x');
                });
              }
              setState(() {});
            },
            child: Text(timerStarted ? "Stop" : "Start"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    print("Hello");
  }
}

class NotificationData {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationDetails notificationDetails;

  NotificationData({
    required this.flutterLocalNotificationsPlugin,
    required this.notificationDetails,
  });
}
