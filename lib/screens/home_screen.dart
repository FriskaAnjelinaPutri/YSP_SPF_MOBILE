import 'dart:ui';
import 'package:apk_absebsi/models/absensi_history_model.dart';
import 'package:apk_absebsi/screens/absensi_detail_screen.dart';
import 'package:apk_absebsi/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:apk_absebsi/screens/akun_screen.dart';
import 'package:intl/intl.dart';
import 'package:apk_absebsi/screens/cuti_list_screen.dart';
import 'package:apk_absebsi/screens/lembur_list_screen.dart';
import 'package:apk_absebsi/screens/absen_masuk_screen.dart';
import 'package:apk_absebsi/screens/absen_keluar_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:apk_absebsi/services/absensi_service.dart';
import 'package:apk_absebsi/models/absensi_model.dart';

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
  late Future<AbsensiHistory?> _absensiHistory;
  late Future<Map<String, dynamic>?> _todayStatusFuture;

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Hitung periode bulan ini otomatis
    final String currentPeriode = DateFormat('yyyy-MM').format(DateTime.now());
    _absensiHistory = AbsensiService.getAbsensi(widget.token, currentPeriode);
    _todayStatusFuture = _fetchTodayStatus();

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

  Future<Map<String, dynamic>?> _fetchTodayStatus() {
    return AbsensiService.getTodayStatus(widget.token);
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
    final formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loadData();
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            const SizedBox(height: 10),
            _buildAbsenHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbsenSummarySection(Map<String, dynamic> summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ringkasan Absensi Bulan Ini",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _glassInfoCard(Icons.check_circle_outline, "Hadir",
                      (summary['total_hadir'] ?? 0).toString()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _glassInfoCard(Icons.pending_actions_outlined, "Izin",
                      (summary['total_izin'] ?? 0).toString()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _glassInfoCard(Icons.sick_outlined, "Sakit",
                      (summary['total_sakit'] ?? 0).toString()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _glassInfoCard(Icons.cancel_outlined, "Alpha",
                      (summary['total_alpha'] ?? 0).toString()),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAbsenHistorySection() {
    return FutureBuilder<AbsensiHistory?>(
      future: _absensiHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.history.isEmpty) {
          return const Center(child: Text('Tidak ada riwayat absensi.'));
        }

        final absensiData = snapshot.data!;
        final summary = absensiData.summary;
        final history = absensiData.history;
        final recentHistory = history.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAbsenSummarySection(summary),
            const SizedBox(height: 16),
            const Text(
              "Riwayat Absensi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentHistory.length,
              itemBuilder: (context, index) {
                final absensi = recentHistory[index];
                return _buildHistoryItem(absensi);
              },
            ),
          ],
        );
      },
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Hadir':
        return Colors.green.shade600;
      case 'Izin':
        return Colors.blue.shade600;
      case 'Sakit':
        return Colors.orange.shade700;
      default:
        return Colors.red.shade600;
    }
  }

  Widget _buildHistoryItem(Absensi absensi) {
    return _glassCard(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accentGreen.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
              absensi.status == 'Hadir'
                  ? Icons.check_circle_outline
                  : Icons.warning_amber_rounded,
              color: primaryGreen),
        ),
        title: Text(
          DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(absensi.tanggal)),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: primaryGreen,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Masuk: ${absensi.jamMasuk} - Keluar: ${absensi.jamKeluar ?? '-'}',
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _statusColor(absensi.status),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            absensi.status,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AbsensiDetailScreen(token: widget.token, tanggal: absensi.tanggal),
            ),
          ).then((_) => setState(() => _loadData()));
        },
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  softGreen.withOpacity(0.75),
                  Colors.white.withOpacity(0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: accentGreen.withOpacity(0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
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
            border:
                Border.all(color: accentGreen.withAlpha(89), width: 1.4), // 0.35
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
                      _currentPosition != null
                          ? Icons.location_on
                          : Icons.location_off,
                      size: 20,
                      color: primaryGreen,
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _locationStatus,
                      style:
                          const TextStyle(fontSize: 15, color: primaryGreen),
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
              const SizedBox(height: 16),
              FutureBuilder<Map<String, dynamic>?>(
                future: _todayStatusFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 20,
                      child: Center(
                          child:
                              CircularProgressIndicator(strokeWidth: 2.0, color: primaryGreen,)),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Gagal memuat status',
                        style: TextStyle(color: Colors.red));
                  }

                  String status;
                  final data = snapshot.data;
                  if (data != null && data['sudah_check_in'] == true) {
                    if (data['sudah_check_out'] == true) {
                      status = 'Sudah Absen Keluar';
                    } else {
                      status = 'Sudah Absen Masuk';
                    }
                  } else {
                    status = 'Belum Absen';
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Status Hari Ini: $status",
                      style: const TextStyle(
                          color: primaryGreen, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _glassButton("Clock In",
                      AbsenMasukScreen(userPosition: _currentPosition)),
                  _glassButton("Clock Out",
                      AbsenKeluarScreen(userPosition: _currentPosition)),
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
            ? () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
                if (result == true) {
                  setState(() {
                    _loadData();
                  });
                }
              }
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
          padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: primaryGreen),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: primaryGreen.withAlpha(179), // 0.7
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
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
