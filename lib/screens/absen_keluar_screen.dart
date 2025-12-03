import 'package:flutter/material.dart';
import '../services/api_services.dart';

class AbsenKeluarScreen extends StatefulWidget {
  final String token; // terima token dari HomeScreen

  const AbsenKeluarScreen({super.key, required this.token});

  @override
  State<AbsenKeluarScreen> createState() => _AbsenKeluarScreenState();
}

class _AbsenKeluarScreenState extends State<AbsenKeluarScreen> {
  bool _sudahAbsen = false;
  String _waktuAbsen = "";

  void _absenKeluar() async {
    // Panggil API dengan token dari HomeScreen
    final response = await ApiService.absenPulang(widget.token);

    final now = DateTime.now();
    setState(() {
      _sudahAbsen = true;
      _waktuAbsen =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
          Text(response?['message'] ?? "Absen Pulang berhasil")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Absen Pulang"), backgroundColor: Colors.red),
      body: Center(
        child: _sudahAbsen
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text("Absen Pulang Berhasil!",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Waktu: $_waktuAbsen"),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text("Tekan tombol untuk Absen Pulang",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _absenKeluar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ABSEN PULANG",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
