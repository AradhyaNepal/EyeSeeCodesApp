import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'notification_work_manager.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isStarted = false;
  bool isLoading = true;
  String value = "value";

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    isStarted = (await SharedPreferences.getInstance()).getBool(value) ?? false;
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notify Eye Rest"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    isLoading = true;
                    setState(() {});
                    final sharedPref = await SharedPreferences.getInstance();
                    if (isStarted) {
                      await Workmanager().cancelAll();
                    } else {
                      await Workmanager().initialize(callbackDispatcher,
                          isInDebugMode:
                              true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
                          );
                      await Workmanager().registerOneOffTask(
                        "send_notification",
                        "simpleTask",
                      );
                    }
                    isStarted=!isStarted;
                    await sharedPref.setBool(value, isStarted);
                    setState(() {});
                  },
                  child: Text(isStarted?"Stop":"Start"),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

