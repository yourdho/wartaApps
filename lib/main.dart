import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wartaapps/utils/Storage.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const WartaApp());
}

class WartaApp extends StatelessWidget {
  const WartaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warta News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2B4D8C),
          unselectedItemColor: Colors.grey,
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: routes,
    );
  }
}
