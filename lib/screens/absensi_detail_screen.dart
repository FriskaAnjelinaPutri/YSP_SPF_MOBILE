import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apk_absebsi/models/absensi_model.dart';
import 'package:intl/intl.dart';
import 'package:apk_absebsi/services/absensi_service.dart'; // Import service

class AbsensiDetailScreen extends StatefulWidget {
  final String token;
  final String tanggal;

  const AbsensiDetailScreen({super.key, required this.token, required this.tanggal});

  @override
  State<AbsensiDetailScreen> createState() => _AbsensiDetailScreenState();
}

class _AbsensiDetailScreenState extends State<AbsensiDetailScreen> {
  late Future<Map<String, dynamic>?> _detailDataFuture;

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
    _detailDataFuture = AbsensiService.getAbsensiDetail(widget.token, widget.tanggal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: softGreen.withOpacity(0.65),
              elevation: 0,
              title: const Text(
                "Detail Absensi",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: primaryGreen),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _detailDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryGreen));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Detail absensi tidak ditemukan.', style: TextStyle(color: primaryGreen)));
          }

          final detailData = snapshot.data!;
          final absensiMap = detailData['absensi'];
          final Absensi absensi = Absensi.fromJson(absensiMap);
          final String durasiKerja = detailData['durasi_kerja'] ?? 'Belum Absen Keluar';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          softGreen.withOpacity(0.75),
                          Colors.white.withOpacity(0.25),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailItem("Tanggal",
                            DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(absensi.tanggal))),
                        const SizedBox(height: 16),
                        _detailItem("Jam Masuk", absensi.jamMasuk),
                        const SizedBox(height: 16),
                        _detailItem("Jam Keluar", absensi.jamKeluar ?? '-'),
                        const SizedBox(height: 16),
                        _detailItem("Durasi Kerja", durasiKerja),
                        const SizedBox(height: 16),
                        _statusBadge(absensi.status),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.55),
        border: Border.all(color: accentGreen.withOpacity(0.35), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: primaryGreen,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'Hadir':
        color = Colors.green.shade600;
        break;
      case 'Izin':
        color = Colors.blue.shade600;
        break;
      case 'Sakit':
        color = Colors.orange.shade700;
        break;
      default:
        color = Colors.red.shade600;
    }

    return Row(
      children: [
        const Text(
          "Status: ",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
