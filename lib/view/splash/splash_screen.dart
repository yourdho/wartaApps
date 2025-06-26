import 'package:flutter/material.dart';
import 'splash_page1.dart';
import 'splash_page2.dart';
import 'splash_page3.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
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
        children: pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child:
            _currentPage < 2
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(pages.length, (index) {
                    return GestureDetector(
                      onTap: () => _goToPage(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 12 : 8,
                        height: _currentPage == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _currentPage == index ? Colors.blue : Colors.grey,
                        ),
                      ),
                    );
                  }),
                )
                : ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2B4D8C), // Biru tua dari logo
                          Color(0xFF4FA3D1), // Biru muda dari logo
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
      ),
    );
  }
}
