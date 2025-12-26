import 'dart:ui';
import 'package:apk_absebsi/screens/about_us_screen.dart';
import 'package:apk_absebsi/screens/helpdesk_list_screen.dart';
import 'package:apk_absebsi/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:apk_absebsi/screens/akun_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';

class SettingScreen extends StatelessWidget {
  final String token;

  const SettingScreen({
    super.key,
    required this.token,
  });

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: primaryGreen,
          ),
        ),
        centerTitle: true,
        backgroundColor: softGreen.withOpacity(0.6),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ================= LIST SETTINGS =================
          SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                _glassSettingTile(
                  icon: Icons.person,
                  title: "Profile",
                  subtitle: "Informasi akun anda",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AkunScreen(token: token),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                _glassSettingTile(
                  icon: Icons.group,
                  title: "User",
                  subtitle: "Manajemen pengguna",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(token: token),
                      ),
                    ) ;
                  },
                ),
                const SizedBox(height: 12),

                _glassSettingTile(
                  icon: Icons.support_agent,
                  title: "Helpdesk",
                  subtitle: "Bantuan & pengaduan",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HelpdeskListScreen(token: token),
                        )
                    );
                  },
                ),
                const SizedBox(height: 12),

                _glassSettingTile(
                  icon: Icons.info_outline,
                  title: "About Us",
                  subtitle: "Tentang aplikasi",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AboutUsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 350), 
              ],
            ),
          ),

          // ================= LOGOUT =================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Center(
                child: _glassSettingTile(
                  icon: Icons.logout,
                  title: "Logout",
                  subtitle: "",
                  isLogout: true,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text("Konfirmasi Logout"),
                        content: const Text("Apakah Anda yakin ingin logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // GLASS TILE
  // =========================================================
  Widget _glassSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isLogout ? 20 : 18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: isLogout ? 180 : double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isLogout ? 10 : 14,
              horizontal: isLogout ? 12 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  softGreen.withOpacity(0.9),
                  Colors.white.withOpacity(0.35),
                ],
              ),
              borderRadius: BorderRadius.circular(isLogout ? 20 : 18),
              border: Border.all(
                color: isLogout
                    ? Colors.red.withOpacity(0.4)
                    : accentGreen.withOpacity(0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment:
              isLogout ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isLogout ? 10 : 12),
                  decoration: BoxDecoration(
                    color: isLogout
                        ? Colors.red.withOpacity(0.2)
                        : accentGreen.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(isLogout ? 12 : 14),
                  ),
                  child: Icon(
                    icon,
                    size: isLogout ? 20 : 24,
                    color: isLogout ? Colors.red.shade700 : primaryGreen,
                  ),
                ),
                if (!isLogout) const SizedBox(width: 12),
                if (!isLogout)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isLogout ? Colors.red.shade700 : primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: isLogout
                                ? Colors.red.withOpacity(0.7)
                                : primaryGreen.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (isLogout) const SizedBox(width: 8),
                if (isLogout)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
                    ),
                  ),
                if (isLogout) const SizedBox(width: 4),
                if (isLogout)
                  Icon(
                    Icons.chevron_right,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
