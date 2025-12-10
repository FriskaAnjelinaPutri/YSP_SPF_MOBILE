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
  // CONTROLLERS
  // =======================
  late final TextEditingController _karKodeController; // <<-- BARU DITAMBAH

  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _hpController;
  late final TextEditingController _waController;
  late final TextEditingController _alamatController;

  late final TextEditingController _nikController;
  late final TextEditingController _nipController;
  late final TextEditingController _jekelController;
  late final TextEditingController _lahirTmpController;
  late final TextEditingController _lahirTglController;
  late final TextEditingController _emailPerusahaanController;
  late final TextEditingController _norekController;
  late final TextEditingController _bankController;
  late final TextEditingController _bpjsController;
  late final TextEditingController _jamsostekController;
  late final TextEditingController _npwpController;
  late final TextEditingController _agamaController;
  late final TextEditingController _statusController;
  late final TextEditingController _tglMasukController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final k = widget.karyawanData;

    // Kode karyawan (READ ONLY)
    _karKodeController = TextEditingController(text: k['kar_kode'] ?? '');

    // Data utama
    _namaController = TextEditingController(text: k['kar_nama'] ?? '');
    _emailController = TextEditingController(text: k['kar_email'] ?? '');
    _hpController = TextEditingController(text: k['kar_hp'] ?? '');
    _waController = TextEditingController(text: k['kar_wa'] ?? '');
    _alamatController = TextEditingController(text: k['kar_alamat'] ?? '');

    // Data tambahan
    _nikController = TextEditingController(text: k['kar_nik'] ?? '');
    _nipController = TextEditingController(text: k['kar_nip'] ?? '');
    _jekelController = TextEditingController(text: k['kar_jekel'] ?? '');
    _lahirTmpController = TextEditingController(text: k['kar_lahir_tmp'] ?? '');
    _lahirTglController = TextEditingController(text: k['kar_lahir_tgl'] ?? '');
    _emailPerusahaanController = TextEditingController(text: k['kar_email_perusahaan'] ?? '');
    _norekController = TextEditingController(text: k['kar_norek'] ?? '');
    _bankController = TextEditingController(text: k['kar_bank'] ?? '');
    _bpjsController = TextEditingController(text: k['kar_nobpjs'] ?? '');
    _jamsostekController = TextEditingController(text: k['kar_nojamsostek'] ?? '');
    _npwpController = TextEditingController(text: k['kar_npwp'] ?? '');
    _agamaController = TextEditingController(text: k['kar_agama'] ?? '');
    _statusController = TextEditingController(text: k['kar_status'] ?? '');
    _tglMasukController = TextEditingController(text: k['kar_tgl_masuk'] ?? '');
  }

  @override
  void dispose() {
    _karKodeController.dispose(); // <-- jangan lupa

    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _waController.dispose();
    _alamatController.dispose();

    _nikController.dispose();
    _nipController.dispose();
    _jekelController.dispose();
    _lahirTmpController.dispose();
    _lahirTglController.dispose();
    _emailPerusahaanController.dispose();
    _norekController.dispose();
    _bankController.dispose();
    _bpjsController.dispose();
    _jamsostekController.dispose();
    _npwpController.dispose();
    _agamaController.dispose();
    _statusController.dispose();
    _tglMasukController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF14532D);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: mainGreen,
        title: const Text(
          "Edit Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // HEADER PROFILE GLASS
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.60),
                        Colors.white.withOpacity(0.25),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.green.withOpacity(0.25),
                        child: Text(
                          widget.karyawanData['kar_nama'][0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            color: mainGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.karyawanData['kar_nama'] ?? "-",
                        style: const TextStyle(
                          fontSize: 20,
                          color: mainGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =======================
            // FORM BAGIAN: KODE KARYAWAN
            // =======================
            _glassSection("Identitas Karyawan", [
              _buildReadOnlyField("Kode Karyawan", _karKodeController, Icons.verified),
            ]),

            const SizedBox(height: 20),

            // =======================
            // FORM UTAMA
            // =======================
            _glassSection("Informasi Utama", [
              _buildField("Nama Lengkap", _namaController, Icons.person),
              _buildField("Email", _emailController, Icons.email),
              _buildField("No HP", _hpController, Icons.phone_android),
              _buildField("No WA", _waController, Icons.phone),
              _buildField("Alamat", _alamatController, Icons.home),
            ]),

            const SizedBox(height: 20),

            _glassSection("Data Pribadi", [
              _buildField("NIK", _nikController, Icons.credit_card),
              _buildField("NIP", _nipController, Icons.badge),
              _buildField("Jenis Kelamin", _jekelController, Icons.people),
              _buildField("Tempat Lahir", _lahirTmpController, Icons.location_on),
              _buildField("Tanggal Lahir", _lahirTglController, Icons.calendar_month),
              _buildField("Agama", _agamaController, Icons.self_improvement),
              _buildField("Status", _statusController, Icons.group),
            ]),

            const SizedBox(height: 20),

            _glassSection("Informasi Karyawan", [
              _buildField("Email Perusahaan", _emailPerusahaanController, Icons.email_outlined),
              _buildField("Tanggal Masuk", _tglMasukController, Icons.event_available),
            ]),

            const SizedBox(height: 20),

            _glassSection("Data Keuangan & Kesehatan", [
              _buildField("No Rekening", _norekController, Icons.account_balance),
              _buildField("Bank", _bankController, Icons.account_balance_wallet),
              _buildField("No BPJS", _bpjsController, Icons.health_and_safety),
              _buildField("No Jamsostek", _jamsostekController, Icons.health_and_safety_outlined),
              _buildField("NPWP", _npwpController, Icons.numbers),
            ]),

            const SizedBox(height: 30),

            // BUTTON SIMPAN
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.65),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: mainGreen),
                      ),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: mainGreen)
                        : const Text(
                      "Simpan Perubahan",
                      style: TextStyle(
                        color: mainGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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

  // ==============================
  // GLASS SECTION CONTAINER
  // ==============================
  Widget _glassSection(String title, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.55),
                Colors.white.withOpacity(0.18),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14532D),
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

  // ==============================
  // READ ONLY FIELD
  // ==============================
  Widget _buildReadOnlyField(
      String label, TextEditingController controller, IconData icon) {
    const mainGreen = Color(0xFF14532D);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: mainGreen),
          labelText: label,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.25),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: mainGreen.withOpacity(0.45)),
          ),
        ),
      ),
    );
  }

  // ==============================
  // FIELD NORMAL
  // ==============================
  Widget _buildField(
      String label, TextEditingController controller, IconData icon) {
    const mainGreen = Color(0xFF14532D);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: mainGreen),
          labelText: label,
          filled: true,
          fillColor: Colors.white.withOpacity(0.60),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: mainGreen.withOpacity(0.45)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: mainGreen, width: 1.4),
          ),
        ),
      ),
    );
  }

  // ==============================
  // SAVE DATA (TANPA MENGIRIM KAR_KODE)
  // ==============================
  Future<void> _saveData() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _hpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Nama, Email & No HP wajib diisi")),
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

      "kar_nik": _nikController.text,
      "kar_nip": _nipController.text,
      "kar_jekel": _jekelController.text,
      "kar_lahir_tmp": _lahirTmpController.text,
      "kar_lahir_tgl": _lahirTglController.text,
      "kar_email_perusahaan": _emailPerusahaanController.text,
      "kar_norek": _norekController.text,
      "kar_bank": _bankController.text,
      "kar_nobpjs": _bpjsController.text,
      "kar_nojamsostek": _jamsostekController.text,
      "kar_npwp": _npwpController.text,
      "kar_agama": _agamaController.text,
      "kar_status": _statusController.text,
      "kar_tgl_masuk": _tglMasukController.text,
    };

    final success = await ApiService.updateProfile(widget.token, updatedData);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profil berhasil diperbarui")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Gagal memperbarui profil")),
      );
    }
  }
}
