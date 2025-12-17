import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apk_absebsi/screens/akun_screen.dart';
import 'package:intl/intl.dart';
import 'package:apk_absebsi/screens/cuti_list_screen.dart';
import 'package:apk_absebsi/screens/lembur_list_screen.dart';
import 'package:apk_absebsi/screens/absen_masuk_screen.dart';
import 'package:apk_absebsi/screens/absen_keluar_screen.dart';

class HomeScreen extends StatefulWidget {
  final String namaPegawai;
  final String role;
  final String token;
  final String karKode;

  const HomeScreen({
    super.key,
    required this.namaPegawai,
    required this.role,
    required this.token,
    required this.karKode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomePage(),
      CutiListScreen(token: widget.token, karKode: widget.karKode),
      LemburListScreen(token: widget.token),
      AkunScreen(token: widget.token),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildGlassBottomBar(),
    );
  }

  // =========================================================
  // HOME PAGE
  // =========================================================
  Widget _buildHomePage() {
    final formattedDate =
    DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome 👋",
                      style: TextStyle(
                        fontSize: 15,
                        color: primaryGreen.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.namaPegawai,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryGreen.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),
              ),
              _glassAvatar(widget.namaPegawai),
            ],
          ),

          const SizedBox(height: 30),

          _glassClockCard(formattedTime),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: _glassInfoCard(
                    Icons.access_time_rounded, "Working Hours", "168h total"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _glassInfoCard(
                    Icons.calendar_month_rounded, "Leave Days", "5 / 20 used"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // AVATAR (LOGIN STYLE)
  // =========================================================
  Widget _glassAvatar(String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: softGreen.withOpacity(0.65),
            shape: BoxShape.circle,
            border: Border.all(color: accentGreen, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.25),
                blurRadius: 14,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.4),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CLOCK CARD (MATCH LOGIN CARD)
  // =========================================================
  Widget _glassClockCard(String time) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                softGreen.withOpacity(0.95),
                Colors.white.withOpacity(0.45),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: accentGreen.withOpacity(0.35), width: 1.4),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.25),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on,
                      size: 20, color: primaryGreen),
                  SizedBox(width: 6),
                  Text(
                    "Office - Main Building",
                    style: TextStyle(
                      fontSize: 15,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _glassButton("Clock In", const AbsenMasukScreen()),
                  _glassButton("Clock Out", const AbsenKeluarScreen()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassButton(String label, Widget page) {
    return SizedBox(
      width: 135,
      height: 52,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        style: ElevatedButton.styleFrom(
          backgroundColor: softGreen.withOpacity(0.95),
          elevation: 4,
          shadowColor: primaryGreen.withOpacity(0.35),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // INFO CARD
  // =========================================================
  Widget _glassInfoCard(IconData icon, String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                softGreen.withOpacity(0.75),
                Colors.white.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentGreen.withOpacity(0.35)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: primaryGreen),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryGreen.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BOTTOM BAR (LOGIN STYLE)
  // =========================================================
  Widget _buildGlassBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: softGreen.withOpacity(0.65),
          selectedItemColor: primaryGreen,
          unselectedItemColor: primaryGreen.withOpacity(0.55),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_history_rounded), label: "Leave"),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled), label: "Overtime"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
