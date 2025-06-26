// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../view/auth/login_page.dart' show LoginPage;
import '../view/auth/register_page.dart' show RegisterPage;
import '../view/detail/detail_page.dart' show DetailPage;
import '../view/home/home_page.dart' show HomePage;
import '../view/splash/splash_page1.dart' show SplashPage1;
import '../view/splash/splash_page2.dart' show SplashPage2;
import '../view/splash/splash_page3.dart' show SplashPage3;
import '../view/splash/splash_screen.dart'; // Bukan splash_page1


class AppRoutes {
static get splash => '/';
  static const splash1 = '/splash1';
  static const splash2 = '/splash2';
  static const splash3 = '/splash3';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const detail = '/detail';

}

final Map<String, WidgetBuilder> routes = {
    AppRoutes.splash: (_) => const SplashScreen(),
  AppRoutes.splash1: (_) => const SplashPage1(),
  AppRoutes.splash2: (_) => const SplashPage2(),
  AppRoutes.splash3: (_) => const SplashPage3(),
  AppRoutes.login: (_) => const LoginPage(),
  AppRoutes.register: (_) => const RegisterPage(),
  AppRoutes.home: (_) => const HomePage(),
  AppRoutes.detail: (_) => const DetailPage(),
};
