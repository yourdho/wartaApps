import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wartaapps/routes/app_routes.dart';
import 'package:wartaapps/view/splash/splash_page1.dart';
import 'package:wartaapps/view/splash/splash_page2.dart';
import 'package:wartaapps/view/splash/splash_page3.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _goToPage(_currentPage + 1);
      } else {
        timer.cancel();
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = const [SplashPage1(), SplashPage2(), SplashPage3()];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const ClampingScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child:
            _currentPage < 2
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: _currentPage == index ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index
                                ? Colors.blue
                                : Colors.grey.withOpacity(0.5),
                      ),
                    );
                  }),
                )
                : ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2B4D8C), Color(0xFF4FA3D1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: const Text(
                        'Mulai',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
