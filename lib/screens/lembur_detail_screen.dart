import 'package:flutter/material.dart';
import '../services/lembur_service.dart';

class LemburDetailScreen extends StatefulWidget {
  final String token;
  final Map lembur;

  const LemburDetailScreen({
    super.key,
    required this.token,
    required this.lembur,
  });

  @override
  State<LemburDetailScreen> createState() => _LemburDetailScreenState();
}

class _LemburDetailScreenState extends State<LemburDetailScreen> {
  Map<String, dynamic>? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final data = await LemburService.getDetail(
        token: widget.token,
        id: int.parse(widget.lembur["id"].toString()), // FIX aman
      );

      setState(() {
        detail = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> batalLembur() async {
    final response = await LemburService.batalLembur(
      token: widget.token,
      id: int.parse(widget.lembur["id"].toString()),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"])),
    );

    if (response["success"] == true) {
      Navigator.pop(context, true); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Lembur"),
        backgroundColor: Colors.orange,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? const Center(child: Text("Gagal memuat detail lembur"))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            infoItem("Tanggal", detail!["lembur"]["tanggal"]),
            infoItem("Jam Mulai", detail!["lembur"]["jam_mulai"]),
            infoItem("Jam Selesai", detail!["lembur"]["jam_selesai"]),
            infoItem(
                "Durasi", detail!["durasi_text"] ?? "-"),
            infoItem("Alasan", detail!["lembur"]["alasan"]),
            infoItem("Status", detail!["lembur"]["status"]),

            const SizedBox(height: 25),

            if (detail!["dapat_dibatalkan"] == true)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14),
                ),
                onPressed: batalLembur,
                child: const Text(
                  "Batalkan Lembur",
                  style: TextStyle(color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget infoItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange.shade50,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
