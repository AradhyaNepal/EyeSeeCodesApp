import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:eye_see_codes/local_storage.dart';
import 'package:flutter/material.dart';
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

  bool isTestMode = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    isStarted = LocalStorage().isSubscribedForNotification;
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
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      isLoading = true;
                      setState(() {});
                      if (isStarted) {
                        await Workmanager().cancelAll();
                      } else {
                        await Workmanager().initialize(callbackDispatcher);
                        if (isTestMode) {
                          _testModeSetup();
                        } else {
                          await LocalStorage().resetShortRest();
                          // final int helloAlarmID = 0;
                          // await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);
                          Workmanager().registerPeriodicTask(
                            "simpleTask",
                            "Title",
                            frequency: const Duration(minutes: 15),
                            initialDelay: const Duration(minutes: 15),
                            existingWorkPolicy: ExistingWorkPolicy.keep,
                          );
                        }
                      }
                      isLoading = false;
                      isStarted = !isStarted;
                      await LocalStorage().subscribeNotificationToggle(isStarted);
                      setState(() {});
                    },
                    child: Text(isStarted ? "Stop" : "Start"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Test Mode"),
                      const SizedBox(
                        width: 10,
                      ),
                      Switch(
                          value: isTestMode,
                          onChanged: (value) {
                            setState(() {
                              isTestMode = value;
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  void _testModeSetup() {
    const totalDuration = Duration(minutes: 1);
    const interval = Duration(seconds: 10);
    for (Duration duration = Duration.zero;
        duration.inMilliseconds <= totalDuration.inMilliseconds;
        duration = Duration(
            milliseconds: duration.inMilliseconds + interval.inMilliseconds)) {
      Workmanager().registerOneOffTask(
        "send_notification${duration.inMilliseconds}",
        "simpleTask",
        initialDelay: duration,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}




