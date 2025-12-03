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

    _namaController = TextEditingController(text: k['kar_nama'] ?? '');
    _emailController = TextEditingController(text: k['kar_email'] ?? '');
    _hpController = TextEditingController(text: k['kar_hp'] ?? '');
    _waController = TextEditingController(text: k['kar_wa'] ?? '');
    _alamatController = TextEditingController(text: k['kar_alamat'] ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _waController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.teal.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: accentColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField("Nama Lengkap", _namaController, Icons.person),
            _buildTextField("Email", _emailController, Icons.email),
            _buildTextField("No HP", _hpController, Icons.phone_android),
            _buildTextField("No WA", _waController, Icons.phone),
            _buildTextField("Alamat", _alamatController, Icons.home),
            const SizedBox(height: 25),

            // tombol simpan
            Center(
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveData,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal.shade600),
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: Colors.teal.shade700, width: 1.5),
          ),
        ),
      ),
    );
  }

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
