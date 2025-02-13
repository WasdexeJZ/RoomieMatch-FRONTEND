import 'dart:async';
import 'dart:convert';

import 'package:supertokens_flutter/supertokens.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ntfy_dart/ntfy_dart.dart';

// import 'package:unifiedpush/unifiedpush.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'services/auth_service.dart';
import 'services/hive_service.dart';

import 'models/profile.dart';
import 'models/settings.dart';
import 'models/auth.dart';
import 'models/user.dart';

import 'views/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initSupertoken();
  await _initHive();
  await _initAuth();
  await _initNtfy();

  runApp(MyApp());
}

void _initSupertoken() {
  SuperTokens.init(
    apiDomain: "http://localhost:8000",
    apiBasePath: "/api/v1/auth",
  );
}

Future<void> _initHive() async {
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

Future<void> _initAuth() async {
  // Set default Auth Model and update if Authentication True
  HiveService.setAuth(Auth());
  await AuthService.checkAuth();
}

Future<void> _initNtfy() async {
  final String topic = 'test';

  final NtfyClient ntfyClient = NtfyClient(basePath: Uri.parse("http://localhost:9980"));

  // Subscribe to the topic(s), receiving the MessageResponses right as they are published
  // final Stream<MessageResponse> ntfyStream = (await ntfyClient.getMessageStream([topic],filters: FilterOptions(id: "")));
  final Stream<MessageResponse> ntfyStream = (await ntfyClient.getMessageStream([topic]));

  // listen to our stream for messages sent to the topic, instantaneous update
  final StreamSubscription<MessageResponse> ntfyListen = ntfyStream.listen((event) {
    if (event.event == EventTypes.message) {
      //  again note other event types will periodically be sent here, but will be empty
      // print(event.title);
      // print(event.message);
      Map<String, dynamic> notification = jsonDecode(event.message ?? '{"userId": "", "message":""}');
      print(notification['userId']);
      print(notification['message']);

      return;
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roommate Matching App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: WelcomePage(title: 'RoomieMatch'),
    );
  }
}
