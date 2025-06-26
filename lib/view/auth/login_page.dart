import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Color(0xFF2B4D8C)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Image.asset('assets/images/logos_warta.png', width: 250),
              ),

              const SizedBox(height: 100),

              // Username / Email
              TextField(
                decoration: inputDecoration.copyWith(
                  hintText: 'Username atau Email',
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                obscureText: true,
                decoration: inputDecoration.copyWith(hintText: 'Password'),
              ),
              const SizedBox(height: 10),

              // Lupa Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(color: Color(0xFF2B4D8C)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol Masuk
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B4D8C),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 160),

              // Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('atau Daftar dengan'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 40),

              // Social Media Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/google.png'),
                  ),
                  const SizedBox(width: 28),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/x.png'),
                  ),
                  const SizedBox(width: 28),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/fb.png'),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Ayo Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Ayo Daftar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
