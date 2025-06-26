import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAgreed = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset('assets/images/logos_warta.png', height: 120),
              ),

              const SizedBox(height: 30),
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: 'Nama Lengkap'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: 'Alamat Email'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: inputDecoration.copyWith(hintText: 'Kata Sandi'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: inputDecoration.copyWith(
                  hintText: 'Ulang Kata Sandi',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: inputDecoration.copyWith(hintText: 'Nomor Ponsel'),
              ),

              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged:
                        (value) => setState(() => isAgreed = value ?? false),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Dengan mendaftar, saya menyetujui ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          const TextSpan(text: ' dan '),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B4D8C),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 80),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('atau Masuk dengan'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/google.png'),
                  ),
                  SizedBox(width: 24),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/x.png'),
                  ),
                  SizedBox(width: 24),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/fb.png'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Ayo Masuk'),
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
