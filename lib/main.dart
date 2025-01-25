import 'package:RoomieMatch/models/profile.dart';
import 'package:RoomieMatch/models/settings.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'services/auth_service.dart';
import 'services/hive_service.dart';

import 'models/auth.dart';
import 'models/user.dart';

import 'views/welcome.dart';

void main() async {
  SuperTokens.init(
    apiDomain: "http://localhost:8000",
    apiBasePath: "/api/v1/auth",
  );

  WidgetsFlutterBinding.ensureInitialized();

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

  // Set default Auth Model and update if Authentication True
  HiveService.setAuth(Auth());
  await AuthService.checkAuth();

  runApp(MyApp());
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
