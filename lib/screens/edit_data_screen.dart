import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_services.dart';

class EditDataScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> karyawanData;

  const EditDataScreen({
    super.key,
    required this.token,
    required this.karyawanData,
  });

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  // =======================
  // WARNA SESUAI DASHBOARD
  // =======================
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  // =======================
  // CONTROLLERS
  // =======================
  late final TextEditingController _karKodeController;
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _hpController;
  late final TextEditingController _waController;
  late final TextEditingController _alamatController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final k = widget.karyawanData;

    // Read-only
    _karKodeController = TextEditingController(text: k['kar_kode'] ?? '');

    // Informasi Utama (editable)
    _namaController = TextEditingController(text: k['kar_nama'] ?? '');
    _emailController = TextEditingController(text: k['kar_email'] ?? '');
    _hpController = TextEditingController(text: k['kar_hp'] ?? '');
    _waController = TextEditingController(text: k['kar_wa'] ?? '');
    _alamatController = TextEditingController(text: k['kar_alamat'] ?? '');
  }

  @override
  void dispose() {
    _karKodeController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _waController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: softGreen.withOpacity(0.65),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Edit Profil",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =======================
            // HEADER PROFILE GLASS
            // =======================
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
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
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: softGreen.withOpacity(0.4),
                        child: Text(
                          widget.karyawanData['kar_nama'][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.karyawanData['kar_nama'] ?? "-",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // =======================
            // KODE KARYAWAN (READ ONLY)
            // =======================
            _glassSection("Identitas Karyawan", [
              _buildReadOnlyField(
                  "Kode Karyawan", _karKodeController, Icons.verified),
            ]),

            const SizedBox(height: 20),

            // =======================
            // INFORMASI UTAMA (EDITABLE)
            // =======================
            _glassSection("Informasi Utama", [
              _buildField("Nama Lengkap", _namaController, Icons.person),
              _buildField("Email", _emailController, Icons.email),
              _buildField("No HP", _hpController, Icons.phone_android),
              _buildField("No WA", _waController, Icons.phone),
              _buildField("Alamat", _alamatController, Icons.home),
            ]),

            const SizedBox(height: 30),

            // =======================
            // BUTTON SIMPAN
            // =======================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =======================
  // GLASS SECTION
  // =======================
  Widget _glassSection(String title, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(height: 14),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  // =======================
  // FIELD READ ONLY
  // =======================
  Widget _buildReadOnlyField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryGreen),
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.55),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: accentGreen.withOpacity(0.35)),
          ),
        ),
      ),
    );
  }

  // =======================
  // FIELD EDITABLE
  // =======================
  Widget _buildField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryGreen),
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.65),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: accentGreen.withOpacity(0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryGreen, width: 1.4),
          ),
        ),
      ),
    );
  }

  // =======================
  // SAVE DATA
  // =======================
  Future<void> _saveData() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _hpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Nama, Email & No HP wajib diisi"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedData = {
      "kar_nama": _namaController.text,
      "kar_email": _emailController.text,
      "kar_hp": _hpController.text,
      "kar_wa": _waController.text,
      "kar_alamat": _alamatController.text,
    };

    final success = await ApiService.updateProfile(widget.token, updatedData);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Profil berhasil diperbarui"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Gagal memperbarui profil"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
