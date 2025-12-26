import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/lembur_service.dart';

class LemburAddScreen extends StatefulWidget {
  final String token;

  const LemburAddScreen({
    super.key,
    required this.token,
  });

  @override
  State<LemburAddScreen> createState() => _LemburAddScreenState();
}

class _LemburAddScreenState extends State<LemburAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tanggalC = TextEditingController();
  final TextEditingController jamMulaiC = TextEditingController();
  final TextEditingController jamSelesaiC = TextEditingController();
  final TextEditingController alasanC = TextEditingController();

  bool loading = false;

  // WARNA SESUAI DASHBOARD CUTI
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  Future<void> pilihTanggal() async {
    final tgl = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (tgl != null) {
      tanggalC.text = tgl.toIso8601String().substring(0, 10);
    }
  }

  Future<void> pilihJam(TextEditingController controller) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      controller.text =
          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final data = {
      "tanggal": tanggalC.text,
      "jam_mulai": jamMulaiC.text,
      "jam_selesai": jamSelesaiC.text,
      "alasan": alasanC.text,
    };

    final result = await LemburService.addLembur(
      token: widget.token,
      data: data,
    );

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result["message"]),
        backgroundColor: result["success"] ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (result["success"]) {
      Navigator.pop(context, true);
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
                "Ajukan Lembur",
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
                    color: accentGreen.withOpacity(0.35), width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _glassTextField("Tanggal", Icons.calendar_today, tanggalC,
                        pilihTanggal),
                    const SizedBox(height: 20),
                    _glassTextField("Jam Mulai", Icons.access_time, jamMulaiC,
                        () => pilihJam(jamMulaiC)),
                    const SizedBox(height: 20),
                    _glassTextField(
                        "Jam Selesai", Icons.access_time, jamSelesaiC,
                        () => pilihJam(jamSelesaiC)),
                    const SizedBox(height: 20),
                    _glassTextField(
                        "Alasan Lembur", Icons.notes, alasanC, null,
                        maxLines: 3),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Kirim Pengajuan",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
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
  // GLASS TEXTFIELD
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

  Widget _glassTextField(String label, IconData icon,
      TextEditingController controller, VoidCallback? onTap,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      readOnly: onTap != null,
      onTap: onTap,
      maxLines: maxLines,
      decoration: _glassInputDecoration(label, icon),
      validator: (v) => (v == null || v.isEmpty) ? "$label harus diisi" : null,
    );
  }
}
