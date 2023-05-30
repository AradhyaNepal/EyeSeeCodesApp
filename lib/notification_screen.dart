import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    final bool timerStarted=timer!=null;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notify Eye Rest"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: ()async{
                if(timerStarted){
                  timer?.cancel();
                  timer=null;
                }else{
                  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
                  const AndroidInitializationSettings initializationSettingsAndroid =
                  AndroidInitializationSettings('ic_launcher');
                  const InitializationSettings initializationSettings = InitializationSettings(
                      android: initializationSettingsAndroid,
                  );
                  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
                      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
                  const AndroidNotificationDetails androidNotificationDetails =
                  AndroidNotificationDetails('your channel id', 'your channel name',
                      channelDescription: 'your channel description',
                      importance: Importance.max,
                      priority: Priority.high,
                      ticker: 'ticker');
                  const NotificationDetails notificationDetails =
                  NotificationDetails(android: androidNotificationDetails);
                  timer=Timer.periodic(const Duration(minutes: 5), (timer) async{
                    await flutterLocalNotificationsPlugin.show(
                        0, 'plain title', 'plain body', notificationDetails,
                        payload: 'item x');
                  });
                }
                setState(() {

                });
              },
              child: Text(
                timerStarted?"Stop":"Start"
              ),
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

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    print("Hello");
  }
}
