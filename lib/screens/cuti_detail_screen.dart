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
      appBar: AppBar(
        title: const Text(
          "Detail Cuti",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alasan: ${cuti["alasan"] ?? "-"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text("Tanggal Mulai: ${cuti["tanggal_mulai"] ?? "-"}"),
            Text("Tanggal Selesai: ${cuti["tanggal_selesai"] ?? "-"}"),

            const SizedBox(height: 10),

            Text(
              "Status: ${cuti["status"] ?? "-"}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: cuti["status"] == "APPROVED"
                    ? Colors.green
                    : cuti["status"] == "REJECTED"
                    ? Colors.red
                    : Colors.orange,
              ),
            ),

            const Spacer(),

            // TOMBOL BATAL — hanya muncul jika status masih pending
            if (cuti["status"] == "PENDING")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _confirmBatal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Batalkan Pengajuan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // KONFIRMASI BATAL CUTI
  // ===========================================================
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

  // ===========================================================
  // PROSES BATAL CUTI (API)
  // ===========================================================
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

      // kembali ke list & refresh
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
