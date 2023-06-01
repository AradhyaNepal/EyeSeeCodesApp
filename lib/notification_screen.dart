import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:eye_see_codes/local_storage.dart';
import 'package:flutter/material.dart';

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

  int id=1;

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
                        await AndroidAlarmManager.cancel(id);
                      } else {
                        if (isTestMode) {
                          _testModeSetup();
                        } else {
                          await LocalStorage().resetShortRest();
                          AndroidAlarmManager.periodic(
                            const Duration(minutes: 10),
                            id,
                              callbackDispatcher,

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
    AndroidAlarmManager.periodic(
      const Duration(seconds: 10),
      id,
      callbackDispatcher,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}




