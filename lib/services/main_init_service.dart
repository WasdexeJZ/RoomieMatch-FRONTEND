import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:supertokens_flutter/supertokens.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ntfy_dart/ntfy_dart.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'api_service.dart';
import 'auth_service.dart';
import 'cryptography_service.dart';
import 'hive_service.dart';

import '../models/auth.dart';
import '../models/profile.dart';
import '../models/settings.dart';
import '../models/user.dart';

import '../helpers/auth_box_helper.dart';

import '../main.dart';

class MainInitService {
  MainInitService();

  static void initSupertoken() {
    SuperTokens.init(
      apiDomain: "http://localhost:8000",
      apiBasePath: "/api/v1/auth",
    );
  }
  
  static Future<void> initHive() async {
    // Initialize Hive
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);

    // Register Hive adapter for data Model
    Hive.registerAdapter(AuthAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(SettingsAdapter());

    // Open Hive Boxes
    await Hive.openBox('authBox');
    await Hive.openBox('appBox');
  }

  static Future<void> initAuth() async {
    // Set default Auth Model and update if Authentication True
    HiveService.setAuth(Auth());
    await AuthService.checkAuth();
  }

  static Future<void> requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    final NotificationPermission notificationPermission = await FlutterForegroundTask.checkNotificationPermission();

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      if (notificationPermission != NotificationPermission.granted) {
        await FlutterForegroundTask.requestNotificationPermission();
      }
    }
  }

  static void initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'RoomieMatch Notification is Running',
        notificationText: '',
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }

  static Future<void> initNtfy(FlutterLocalNotificationsPlugin notificationsPlugin, NotificationDetails notificationDetails, NotificationDetails summaryNotificationDetails) async {
    bool connectionEstablished = false;
    bool isIteration = false;

    do {
      try {
        final String topic = 'notifications';
        final NtfyClient ntfyClient = NtfyClient(basePath: Uri.parse("http://localhost:9980"));

        // Subscribe to the topic(s), receiving the MessageResponses right as they are published
        final Stream<MessageResponse> ntfyStream = (await ntfyClient.getMessageStream([topic]));

        int counter = 0;

        // listen to our stream for messages sent to the topic, instantaneous update
        final StreamSubscription<MessageResponse> ntfyListen = ntfyStream.listen((event) async {
          if (event.event == EventTypes.message) {
            Map<String, dynamic> notification = jsonDecode(event.message ?? '{"userId": "", "title":"", "message":""}');

            if (notification['userId'].compareTo(AuthBoxHelper.getUserId()) == 0) {
              String message = await CryptographyService.decryptRSA(notification['message']);

              await notificationsPlugin.show(counter, notification['title'], message, notificationDetails);
              counter++;

              if ((await notificationsPlugin.getActiveNotifications()).length == 2) {
                await notificationsPlugin.show(counter, "", "", summaryNotificationDetails);
              }
              counter++;
            }
          }
        }, onError: (e) {
          initNtfy(notificationsPlugin, notificationDetails, summaryNotificationDetails);
        });

        connectionEstablished = true;
      } catch (c) {
        connectionEstablished = false;
      }

      if (isIteration) {
        await Future.delayed(Duration(seconds: 30));
      }

      isIteration = true;
    } while (!connectionEstablished);
  }

  static Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);

    FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationsPlugin.initialize(initSettings);

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'RoomieMatch',
      'RoomieMatch',
      importance: Importance.high,
      priority: Priority.high,
      groupKey: "RoomieMatch",
    );

    const AndroidNotificationDetails summaryAndroidNotificationDetails = AndroidNotificationDetails(
      'RoomieMatch',
      'RoomieMatch',
      importance: Importance.high,
      priority: Priority.high,
      groupKey: "RoomieMatch",
      setAsGroupSummary: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    const NotificationDetails summaryNotificationDetails = NotificationDetails(android: summaryAndroidNotificationDetails);

    await initNtfy(notificationsPlugin, notificationDetails, summaryNotificationDetails);
  }
}

class MyTaskHandler extends TaskHandler {
  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    MainInitService.initSupertoken();
    await MainInitService.initHive();
    await MainInitService.initNotification();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp) async {}

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}
