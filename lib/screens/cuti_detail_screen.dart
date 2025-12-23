import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/cuti_service.dart';

class CutiDetailScreen extends StatelessWidget {
  final Map cuti;
  final String token;
  final String karKode;

  const CutiDetailScreen({
    super.key,
    required this.cuti,
    required this.token,
    required this.karKode,
  });

  // WARNA SESUAI DASHBOARD
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      // =============================
      //      APPBAR GLASS STYLE
      // =============================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: softGreen.withOpacity(0.65),
              elevation: 0,
              title: const Text(
                "Detail Cuti",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
      ),

      body: Padding(
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
                    _detailItem("Alasan", cuti["alasan"]),
                    const SizedBox(height: 16),
                    _detailItem("Tanggal Mulai", cuti["tanggal_mulai"]),
                    const SizedBox(height: 16),
                    _detailItem("Tanggal Selesai", cuti["tanggal_selesai"]),
                    const SizedBox(height: 16),
                    _statusBadge(cuti["status"]),
                    const SizedBox(height: 25),
                    if (cuti["status"] == "PENDING")
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _confirmBatal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            "Batalkan Pengajuan",
                            style: TextStyle(color: Colors.white),
                          ),
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

  // =========================================================
  // DETAIL ITEM GLASS STYLE
  // =========================================================
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
              value ?? "-",
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

  // =========================================================
  // STATUS BADGE
  // =========================================================
  Widget _statusBadge(String? status) {
    Color color;
    switch (status) {
      case "APPROVED":
        color = Colors.green.shade600;
        break;
      case "REJECTED":
        color = Colors.red.shade600;
        break;
      default:
        color = Colors.orange.shade700;
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
            status ?? "-",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // KONFIRMASI BATAL CUTI
  // =========================================================
  void _confirmBatal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Batalkan Pengajuan"),
        content: const Text("Yakin ingin membatalkan cuti ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _batalCuti(context);
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROSES BATAL CUTI
  // =========================================================
  Future<void> _batalCuti(BuildContext context) async {
    final response = await CutiService.batalCuti(
      token: token,
      id: cuti["id"].toString(),
      karKode: karKode,
    );

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengajuan cuti berhasil dibatalkan")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? "Gagal membatalkan cuti"),
        ),
      );
    }
  }
}
