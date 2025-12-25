import 'dart:ui';
import 'package:apk_absebsi/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:apk_absebsi/screens/akun_screen.dart';
import 'package:intl/intl.dart';
import 'package:apk_absebsi/screens/cuti_list_screen.dart';
import 'package:apk_absebsi/screens/lembur_list_screen.dart';
import 'package:apk_absebsi/screens/absen_masuk_screen.dart';
import 'package:apk_absebsi/screens/absen_keluar_screen.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? _currentPosition;
  String _locationStatus = "Mencari Lokasi...";
  bool _isFetchingLocation = false;

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
      SettingScreen(token: widget.token),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    if (_isFetchingLocation) return;

    if (mounted) {
      setState(() {
        _isFetchingLocation = true;
        _locationStatus = "Mencari Lokasi...";
      });
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Layanan Lokasi Nonaktif'),
            content:
                const Text('Silakan aktifkan layanan lokasi untuk melanjutkan.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw 'Layanan lokasi masih nonaktif.';
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen, aplikasi tidak dapat meminta izin.';
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _locationStatus = "Lokasi Ditemukan";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationStatus = "Gagal Mendapatkan Lokasi";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    _pages[0] = _buildHomePage();

    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildGlassBottomBar(),
    );
  }

  Widget _buildHomePage() {
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        color: primaryGreen.withAlpha(153), // 0.6
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
                        color: primaryGreen.withAlpha(140), // 0.55
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

  Widget _glassAvatar(String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: softGreen.withAlpha(166), // 0.65
            shape: BoxShape.circle,
            border: Border.all(color: accentGreen, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withAlpha(64), // 0.25
                blurRadius: 14,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withAlpha(102), // 0.4
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                softGreen.withAlpha(242), // 0.95
                Colors.white.withAlpha(115), // 0.45
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: accentGreen.withAlpha(89), width: 1.4), // 0.35
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withAlpha(64), // 0.25
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isFetchingLocation)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: primaryGreen,
                      ),
                    )
                  else
                    Icon(
                      _currentPosition != null ? Icons.location_on : Icons.location_off,
                      size: 20,
                      color: primaryGreen,
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _locationStatus,
                      style: const TextStyle(fontSize: 15, color: primaryGreen),
                    ),
                  ),
                  if (_locationStatus == "Gagal Mendapatkan Lokasi")
                    TextButton(
                      onPressed: _getCurrentLocation,
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(
                            color: primaryGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _glassButton(
                      "Clock In", AbsenMasukScreen(userPosition: _currentPosition)),
                  _glassButton(
                      "Clock Out", AbsenKeluarScreen(userPosition: _currentPosition)),
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
        onPressed: _currentPosition != null
            ? () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => page))
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: softGreen.withAlpha(242), // 0.95
          elevation: 4,
          shadowColor: primaryGreen.withAlpha(89), // 0.35
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          disabledBackgroundColor: Colors.grey.withAlpha(128), // 0.5
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
                softGreen.withAlpha(191), // 0.75
                Colors.white.withAlpha(89), // 0.35
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentGreen.withAlpha(89)), // 0.35
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentGreen.withAlpha(51), // 0.2
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: primaryGreen),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryGreen.withAlpha(179), // 0.7
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

  Widget _buildGlassBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: softGreen.withAlpha(166), // 0.65
          selectedItemColor: primaryGreen,
          unselectedItemColor: primaryGreen.withAlpha(140), // 0.55
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_history_rounded), label: "Leave"),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time_filled), label: "Overtime"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Setting"),
          ],
        ),
      ),
    );
  }
}
