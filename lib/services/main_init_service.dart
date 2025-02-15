import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:supertokens_flutter/supertokens.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ntfy_dart/ntfy_dart.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'auth_service.dart';
import 'hive_service.dart';

import '../models/profile.dart';
import '../models/settings.dart';
import '../models/auth.dart';
import '../models/user.dart';

import '../main.dart';

class MainInitService {
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
        notificationTitle: '',
        notificationText: 'RoomieMatch Notification is Running',
        callback: startCallback,
      );
    }
  }

  static Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }

  static Future<void> initNtfy(FlutterLocalNotificationsPlugin notificationsPlugin, NotificationDetails notificationDetails) async {
    final String topic = 'test';
    final NtfyClient ntfyClient = NtfyClient(basePath: Uri.parse("http://localhost:9980"));

    // Subscribe to the topic(s), receiving the MessageResponses right as they are published
    // final Stream<MessageResponse> ntfyStream = (await ntfyClient.getMessageStream([topic],filters: FilterOptions(id: "")));
    final Stream<MessageResponse> ntfyStream = (await ntfyClient.getMessageStream([topic]));

    print("asdf");
    int counter = 0;
    // listen to our stream for messages sent to the topic, instantaneous update
    final StreamSubscription<MessageResponse> ntfyListen = ntfyStream.listen((event) async {
      if (event.event == EventTypes.message) {
        //  again note other event types will periodically be sent here, but will be empty
        // print(event.title);
        // print(event.message);
        Map<String, dynamic> notification = jsonDecode(event.message ?? '{"userId": "", "message":""}');
        print(notification['userId']);
        print(notification['message']);

        await notificationsPlugin.show(counter, notification['userId'], notification['message'], notificationDetails);
        counter++;
      }
    });
  }

  static Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInitSettings);

    FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationsPlugin.initialize(initSettings);

    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    print("ahi");

    await initNtfy(notificationsPlugin, notificationDetails);
  }
}

class MyTaskHandler extends TaskHandler {
  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');

    print('ehehe');

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
