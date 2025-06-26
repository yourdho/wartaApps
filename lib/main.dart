import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
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
      ),
      initialRoute: AppRoutes.splash, // ← splash_screen.dart
      routes: routes, // ← ini sekarang refer ke variable `routes` global
    );
  }
}
