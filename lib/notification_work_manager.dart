
import 'dart:math';
import 'package:eye_see_codes/local_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:vibration/vibration.dart';

@pragma('vm:entry-point')
void callbackDispatcher() async{
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
    const hint='Close Your Eye for 30 seconds or look far object for 30 seconds';
    final localStorage=LocalStorage();
    await localStorage.init(true);
    final isShortRest=localStorage.isShortRest;
    final valueToShow=isShortRest?hint:"Take 5 min rest:\n1)$hint\n2)Water Fill\n3)Washroom\n4)Just evaluate what done and plan will will do by closing eyes\n5)Stretch.";
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.max,
        enableLights: true,
        enableVibration: true,
        colorized: true,
        styleInformation:  BigTextStyleInformation(valueToShow),
        ticker: 'ticker');
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    Logger().i("In Loop");
    Vibration.vibrate(duration: 1500);

    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(1000), 'Rest Time', valueToShow, notificationDetails,
        payload: 'item x');
    await localStorage.toggleShortRest();
  } catch (err) {
    Logger().e("Was here"); // Logger flutter package, prints error on the debug console
    Logger().e(err
        .toString()); // Logger flutter package, prints error on the debug console
    throw Exception(err);
  }
}
