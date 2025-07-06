import 'package:flutter/material.dart';
import 'package:wartaapps/layouts/main_wrapper.dart';
import 'package:wartaapps/view/create/create_article_screen.dart';
import 'package:wartaapps/view/edit/edit_article_screen.dart';
import '../view/auth/login_page.dart';
import '../view/auth/register_page.dart';
import '../view/detail/detail_page.dart';
import '../view/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String createArticle = '/create-article';
  static const String editArticle = '/edit-article';
}

final Map<String, WidgetBuilder> routes = {
  AppRoutes.splash: (_) => const SplashScreen(),
  AppRoutes.login: (_) => const LoginPage(),
  AppRoutes.register: (_) => const RegisterPage(),
  AppRoutes.main: (_) => const MainWrapper(),
  AppRoutes.detail: (_) => const DetailPage(),
  AppRoutes.createArticle: (_) => const CreateArticlePage(),
  AppRoutes.editArticle: (_) => const EditArticlePage(),
};
