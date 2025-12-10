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
      backgroundColor: const Color(0xFFE9F8EE), // Soft green premium
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
    String formattedDate =
    DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome 👋",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.namaPegawai,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF14532D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Avatar glass
              _glassCircleAvatar(widget.namaPegawai),
            ],
          ),

          const SizedBox(height: 28),

          // CLOCK CARD GLASS STYLE
          _glassClockCard(formattedTime),

          const SizedBox(height: 30),

          // INFO CARDS
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

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =========================================================
  // GLASS AVATAR
  // =========================================================
  Widget _glassCircleAvatar(String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.35),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.4,
            ),
          ),
          child: CircleAvatar(
            radius: 27,
            backgroundColor: Colors.green.withOpacity(0.25),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF166534),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // GLASS CLOCK CARD (Premium Neo Glass)
  // =========================================================
  Widget _glassClockCard(String time) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.55),
                Colors.white.withOpacity(0.20),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF166534),
                ),
              ),

              const SizedBox(height: 12),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 20, color: Color(0xFF166534)),
                  SizedBox(width: 6),
                  Text(
                    "Office - Main Building",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF166534),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

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

  // BUTTON GLASS
  Widget _glassButton(String label, Widget page) {
    return SizedBox(
      width: 135,
      height: 52,
      child: ElevatedButton(
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.65),
          shadowColor: Colors.green.withOpacity(0.2),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14532D),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // GLASS INFO CARD
  // =========================================================
  Widget _glassInfoCard(IconData icon, String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.45),
                Colors.white.withOpacity(0.18),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: const Color(0xFF15803D)),
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF064E3B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // GLASS BOTTOM BAR
  // =========================================================
  Widget _buildGlassBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white.withOpacity(0.55),
          selectedItemColor: const Color(0xFF15803D),
          unselectedItemColor: Colors.grey.shade600,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.work_history_rounded), label: "Leave"),
            BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: "Overtime"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
