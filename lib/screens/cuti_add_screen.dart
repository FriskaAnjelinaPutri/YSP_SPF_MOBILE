import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/cuti_service.dart';

class CutiAddScreen extends StatefulWidget {
  final String token;
  final String karKode;

  const CutiAddScreen({
    super.key,
    required this.token,
    required this.karKode,
  });

  @override
  State<CutiAddScreen> createState() => _CutiAddScreenState();
}

class _CutiAddScreenState extends State<CutiAddScreen> {
  final TextEditingController alasanController = TextEditingController();
  final TextEditingController mulaiController = TextEditingController();
  final TextEditingController selesaiController = TextEditingController();

  String? selectedJenis;
  bool loading = false;

  // WARNA SESUAI DASHBOARD
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  Future<void> _pickDate(TextEditingController controller) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      controller.text = selected.toIso8601String().substring(0, 10);
    }
  }

  Future<void> submit() async {
    if (selectedJenis == null ||
        alasanController.text.isEmpty ||
        mulaiController.text.isEmpty ||
        selesaiController.text.isEmpty) {
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

    final result = await CutiService.addCuti(
      token: widget.token,
      karKode: widget.karKode,
      data: {
        "kar_kode": widget.karKode,
        "alasan": alasanController.text,
        "tanggal_mulai": mulaiController.text,
        "tanggal_selesai": selesaiController.text,
        "jenis_cuti": selectedJenis,
      },
    );

    setState(() => loading = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Pengajuan berhasil"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Pengajuan gagal"),
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
                "Pengajuan Cuti",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // =======================
                  // DROPDOWN JENIS CUTI
                  // =======================
                  DropdownButtonFormField<String>(
                    decoration: _glassInputDecoration("Jenis Cuti", Icons.work_history),
                    value: selectedJenis,
                    items: [
                      "Cuti Tahunan",
                      "Cuti Sakit",
                      "Cuti Melahirkan",
                      "Cuti Khusus"
                    ]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedJenis = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // TANGGAL MULAI
                  // =======================
                  TextField(
                    controller: mulaiController,
                    readOnly: true,
                    decoration: _glassInputDecoration("Tanggal Mulai", Icons.calendar_today),
                    onTap: () => _pickDate(mulaiController),
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // TANGGAL SELESAI
                  // =======================
                  TextField(
                    controller: selesaiController,
                    readOnly: true,
                    decoration: _glassInputDecoration("Tanggal Selesai", Icons.calendar_month),
                    onTap: () => _pickDate(selesaiController),
                  ),

                  const SizedBox(height: 20),

                  // =======================
                  // ALASAN CUTI
                  // =======================
                  TextField(
                    controller: alasanController,
                    maxLines: 3,
                    decoration: _glassInputDecoration("Alasan", Icons.notes),
                  ),

                  const SizedBox(height: 30),

                  // =======================
                  // SUBMIT BUTTON
                  // =======================
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
                        "Kirim Pengajuan",
                        style: TextStyle(fontSize: 17, color: Colors.white),
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
  // INPUT DECORATION GLASS STYLE
  // =========================================================
  InputDecoration _glassInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryGreen),
      labelStyle: TextStyle(color: primaryGreen),
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
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }
}
