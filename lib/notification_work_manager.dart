import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:vibration/vibration.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
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
      Logger().i("In Loop");
      Vibration.vibrate(duration: 1000);
      AudioPlayer()..play(AssetSource('audio/blink_time.mp3'))..resume();
      await flutterLocalNotificationsPlugin.show(
          Random().nextInt(1000), 'plain title', 'plain body', notificationDetails,
          payload: 'item x');
    } catch (err) {
      Logger().e("Was here"); // Logger flutter package, prints error on the debug console
      Logger().e(err
          .toString()); // Logger flutter package, prints error on the debug console
      throw Exception(err);
    }
    return Future.value(true);
  });
}
