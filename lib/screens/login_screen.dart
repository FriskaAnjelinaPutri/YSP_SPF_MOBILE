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
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),

              child: Container(
                width: 420,
                padding: const EdgeInsets.all(34),

                /// ================= CARD DECORATION (DIPERJELAS) =================
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD1FAE5).withOpacity(0.95), // hijau jelas
                      const Color(0xFFF0FDF4).withOpacity(0.75),
                      Colors.white.withOpacity(0.45),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFF34D399).withOpacity(0.35),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withOpacity(0.25),
                      blurRadius: 34,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.65),
                      blurRadius: 12,
                      spreadRadius: -6,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                /// ================================================================

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// LOGO
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDCFCE7),
                        border: Border.all(
                          color: const Color(0xFF34D399),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.25),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo_sph.png',
                        width: 62,
                        height: 62,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Employee Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF064E3B),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Attendance & Workforce System",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade900.withOpacity(0.65),
                      ),
                    ),

                    const SizedBox(height: 32),

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

                    const SizedBox(height: 34),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFFDCFCE7).withOpacity(0.95),
                          elevation: 4,
                          shadowColor:
                          const Color(0xFF059669).withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          color: Color(0xFF064E3B),
                        )
                            : const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF064E3B),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "© 2025 Semen Padang Hospital",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade900.withOpacity(0.55),
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

  // ========================= GLASS FIELD =========================
  Widget _glassField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withOpacity(0.35),
                width: 1.2,
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
                prefixIcon: Icon(icon, color: const Color(0xFF15803D)),
                suffixIcon: suffix,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
