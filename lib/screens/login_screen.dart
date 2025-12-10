import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      setState(() => _isLoading = false);
      return;
    }

    final response = await ApiService.login(email, password);
    setState(() => _isLoading = false);

    if (response != null &&
        response['data'] != null &&
        response['data']['access_token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['data']['access_token']);

      final userData = response['data']['user'];
      final role = userData?['role'] ?? 'karyawan';
      final namaPegawai =
          userData?['karyawan']?['kar_nama'] ?? userData?['name'] ?? "Pegawai";

      final karKode = userData?['karyawan']?['kar_kode'] ?? "";
      await prefs.setString('karKode', karKode);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            namaPegawai: namaPegawai,
            role: role,
            token: response['data']['access_token'],
            karKode: karKode,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login gagal, periksa email/password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.55),
                      Colors.white.withOpacity(0.18),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.15),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1.2,
                        ),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        size: 62,
                        color: Color(0xFF15803D),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Employee Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Attendance & Workforce System",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _glassField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      obscure: false,
                    ),

                    const SizedBox(height: 22),

                    _glassField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.65),
                          elevation: 3,
                          shadowColor: Colors.green.withOpacity(0.18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Color(0xFF14532D),
                        )
                            : const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14532D),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "© 2025 Semen Padang Hospital",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =======================================================================
  // GLASS FIELD WIDGET
  // =======================================================================
  Widget _glassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.38),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.55),
                width: 1.1,
              ),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              cursorColor: const Color(0xFF15803D),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF064E3B),
                fontWeight: FontWeight.w500,
              ),

              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

                labelText: label,
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF14532D),
                  fontWeight: FontWeight.bold,
                ),
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.green.shade800.withOpacity(0.75),
                  fontWeight: FontWeight.w600,
                ),

                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 14, right: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F8EF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF15803D),
                  ),
                ),

                suffixIcon: suffix,

                filled: true,
                fillColor: Colors.white.withOpacity(0.15),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.green.withOpacity(0.20),
                    width: 1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFF15803D),
                    width: 1.7,
                  ),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
