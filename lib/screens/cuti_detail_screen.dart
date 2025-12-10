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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE), // warna background dashboard
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green.shade900,
        title: const Text(
          "Detail Cuti",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
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
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailItem("Alasan", cuti["alasan"]),
                  const SizedBox(height: 16),

                  _detailItem("Tanggal Mulai", cuti["tanggal_mulai"]),
                  const SizedBox(height: 8),

                  _detailItem("Tanggal Selesai", cuti["tanggal_selesai"]),
                  const SizedBox(height: 16),

                  // STATUS BADGE
                  Row(
                    children: [
                      const Text(
                        "Status: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF064E3B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(cuti["status"]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cuti["status"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  if (cuti["status"] == "PENDING")
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _confirmBatal(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Batalkan Pengajuan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // GLASS DETAIL ITEM FORMAT
  // ===================================================================
  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF166534),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.35),
            ),
          ),
          child: Text(
            value ?? "-",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF064E3B),
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  // ===================================================================
  // STATUS COLOR PREMIUM STYLE
  // ===================================================================
  Color _statusColor(String? status) {
    switch (status) {
      case "APPROVED":
        return Colors.green.shade600;
      case "REJECTED":
        return Colors.red.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  // ===================================================================
  // KONFIRMASI BATAL CUTI
  // ===================================================================
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

  // ===================================================================
  // PROSES BATAL CUTI
  // ===================================================================
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
