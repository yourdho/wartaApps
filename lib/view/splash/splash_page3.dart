import 'package:flutter/material.dart';

class SplashPage3 extends StatelessWidget {
  const SplashPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logos_warta.png', width: 450),
          const SizedBox(height: 20),
          const Text(
            'Dapatkan berita dari berbagai sumber terpercaya.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
