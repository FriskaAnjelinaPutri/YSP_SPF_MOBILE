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
        const SnackBar(content: Text("Semua field wajib diisi")),
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
        SnackBar(content: Text(result['message'] ?? "Pengajuan berhasil")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Pengajuan gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengajuan Cuti"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==========================
            // DROPDOWN JENIS CUTI
            // ==========================
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Jenis Cuti",
                prefixIcon: const Icon(Icons.work_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              value: selectedJenis,
              items: [
                "Cuti Tahunan",
                "Cuti Sakit",
                "Cuti Melahirkan",
                "Cuti Khusus"
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() => selectedJenis = value);
              },
            ),

            const SizedBox(height: 20),

            // ==========================
            // TANGGAL MULAI
            // ==========================
            TextField(
              controller: mulaiController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Tanggal Mulai",
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () => _pickDate(mulaiController),
            ),

            const SizedBox(height: 20),

            // ==========================
            // TANGGAL SELESAI
            // ==========================
            TextField(
              controller: selesaiController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Tanggal Selesai",
                prefixIcon: const Icon(Icons.calendar_month),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onTap: () => _pickDate(selesaiController),
            ),

            const SizedBox(height: 20),

            // ==========================
            // ALASAN CUTI
            // ==========================
            TextField(
              controller: alasanController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Alasan",
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 30),

            // ==========================
            // SUBMIT BUTTON
            // ==========================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Kirim Pengajuan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
