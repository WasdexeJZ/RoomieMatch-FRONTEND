import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'views/welcome.dart';
import 'services/auth_service.dart';
import 'stores/auth_store.dart';

void main() {
  SuperTokens.init(
    apiDomain: "http://localhost:8000",
    apiBasePath: "/api/v1/auth",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthStore authStore = Provider.of<AuthStore>(context, listen: false);
    final AuthService authService = AuthService(authStore);

    authStore.init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roommate Matching App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: WelcomePage(title: 'RoomieMatch', authStore: authStore, authService: authService),
    );
  }
}
