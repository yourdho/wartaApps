import 'package:flutter/material.dart';
import 'package:wartaapps/routes/app_routes.dart';
import 'package:wartaapps/services/auth_service.dart';
import 'package:wartaapps/utils/Storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "news@itg.ac.id");
  final _passwordController = TextEditingController(text: "ITG#news");
  final _authController = AuthController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Storage.init();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authController.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response.success) {
        await Storage.setToken(response.data.token!);
        await Storage.setIsLoggedIn(true);

        if (response.data.author != null) {
          await Storage.setUserData(
            name: response.data.author!.fullName,
            email: response.data.author!.email,
            userId: response.data.author!.id,
            bio: response.data.author!.bio,
            avatarUrl: response.data.author!.avatarUrl,
          );
        }

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        }
      } else {
        setState(() {
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Image.asset(
                    'assets/images/logos_warta.png',
                    width: 250,
                  ),
                ),
                const SizedBox(height: 100),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B4D8C),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Masuk',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 160),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushNamed(context, AppRoutes.register),
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
      ),
    );
  }
}
