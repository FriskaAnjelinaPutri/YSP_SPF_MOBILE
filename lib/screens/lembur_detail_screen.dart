import 'dart:ui';
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

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final data = await LemburService.getDetail(
        token: widget.token,
        id: int.parse(widget.lembur["id"].toString()),
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
                "Detail Lembur",
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail == null
          ? const Center(child: Text("Gagal memuat detail lembur"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                  infoItem("Tanggal", detail!["lembur"]["tanggal"]),
                  infoItem("Jam Mulai", detail!["lembur"]["jam_mulai"]),
                  infoItem("Jam Selesai", detail!["lembur"]["jam_selesai"]),
                  infoItem("Durasi", detail!["durasi_text"] ?? "-"),
                  infoItem("Alasan", detail!["lembur"]["alasan"]),
                  infoItem("Status", detail!["lembur"]["status"]),

                  const SizedBox(height: 25),

                  if (detail!["dapat_dibatalkan"] == true)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: batalLembur,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          "Batalkan Lembur",
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
    );
  }

  Widget infoItem(String title, String value) {
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
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
