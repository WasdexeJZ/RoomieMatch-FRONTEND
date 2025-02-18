import 'package:flutter/material.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'services/main_init_service.dart';
import 'services/hive_service.dart';

import 'views/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MainInitService.initSupertoken();
  await MainInitService.initHive();
  await MainInitService.initAuth();

  if (HiveService.getAuth()?.isAuthenticated ?? false) {
    await MainInitService.requestPermissions();
    MainInitService.initService();
    await MainInitService.startService();
  } 

  runApp(const MyApp());
}

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
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
