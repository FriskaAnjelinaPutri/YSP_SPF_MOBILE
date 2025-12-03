import 'package:flutter/material.dart';
import '../services/api_services.dart';

class AbsenMasukScreen extends StatefulWidget {
  final String token; // terima token dari HomeScreen

  const AbsenMasukScreen({super.key, required this.token});

  @override
  State<AbsenMasukScreen> createState() => _AbsenMasukScreenState();
}

class _AbsenMasukScreenState extends State<AbsenMasukScreen> {
  bool _sudahAbsen = false;
  String _waktuAbsen = "";

  void _absenMasuk() async {
    // Panggil API dengan token yang diterima dari HomeScreen
    final response = await ApiService.absenMasuk(widget.token);

    final now = DateTime.now();
    setState(() {
      _sudahAbsen = true;
      _waktuAbsen =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response?['message'] ?? "Absen Masuk berhasil")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Absen Masuk"), backgroundColor: Colors.green),
      body: Center(
        child: _sudahAbsen
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Absen Masuk Berhasil!",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Waktu: $_waktuAbsen"),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.login, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("Tekan tombol untuk Absen Masuk",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _absenMasuk,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ABSEN MASUK",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
