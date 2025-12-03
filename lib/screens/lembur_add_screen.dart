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
      SnackBar(content: Text(result["message"])),
    );

    if (result["success"]) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajukan Lembur"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tanggalC,
                readOnly: true,
                onTap: pilihTanggal,
                decoration: const InputDecoration(
                  labelText: "Tanggal",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Tanggal harus diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: jamMulaiC,
                readOnly: true,
                onTap: () => pilihJam(jamMulaiC),
                decoration: const InputDecoration(
                  labelText: "Jam Mulai",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Jam mulai harus diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: jamSelesaiC,
                readOnly: true,
                onTap: () => pilihJam(jamSelesaiC),
                decoration: const InputDecoration(
                  labelText: "Jam Selesai",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Jam selesai harus diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: alasanC,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Alasan Lembur",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Alasan harus diisi" : null,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Kirim Pengajuan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
