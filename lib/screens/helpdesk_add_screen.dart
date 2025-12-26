import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/helpdesk_service.dart';

class HelpdeskAddScreen extends StatefulWidget {
  final String token;

  const HelpdeskAddScreen({
    super.key,
    required this.token,
  });

  @override
  State<HelpdeskAddScreen> createState() => _HelpdeskAddScreenState();
}

class _HelpdeskAddScreenState extends State<HelpdeskAddScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  String prioritas = 'Low';
  bool loading = false;

  // WARNA SESUAI DASHBOARD
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void dispose() {
    judulController.dispose();
    kategoriController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (judulController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => loading = true);

    final result = await HelpdeskService.addHelpdesk(
      token: widget.token,
      judul: judulController.text,
      kategori: kategoriController.text,
      prioritas: prioritas,
      deskripsi: deskripsiController.text,
    );

    setState(() => loading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Helpdesk berhasil dikirim"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Gagal mengirim helpdesk"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      // =============================
      //        APPBAR GLASS
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
                "Ajukan Helpdesk",
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

      body: SingleChildScrollView(
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

              // =============================
              //            FORM
              // =============================
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL
                  TextField(
                    controller: judulController,
                    decoration: _glassInputDecoration(
                      "Judul Helpdesk",
                      Icons.title,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // KATEGORI
                  TextField(
                    controller: kategoriController,
                    decoration: _glassInputDecoration(
                      "Kategori",
                      Icons.category,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PRIORITAS
                  DropdownButtonFormField<String>(
                    value: prioritas,
                    decoration: _glassInputDecoration(
                      "Prioritas",
                      Icons.priority_high,
                    ),
                    items: const ['Low', 'Medium', 'High']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => prioritas = value!);
                    },
                  ),

                  const SizedBox(height: 20),

                  // DESKRIPSI
                  TextField(
                    controller: deskripsiController,
                    maxLines: 4,
                    decoration: _glassInputDecoration(
                      "Deskripsi Masalah",
                      Icons.notes,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: loading ? null : submit,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Kirim Helpdesk",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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

  // =========================================================
  // INPUT DECORATION GLASS STYLE (SAMA DENGAN CUTI)
  // =========================================================
  InputDecoration _glassInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryGreen),
      labelStyle: const TextStyle(color: primaryGreen),
      filled: true,
      fillColor: Colors.white.withOpacity(0.55),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentGreen.withOpacity(0.35)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentGreen.withOpacity(0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }
}
