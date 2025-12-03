import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'edit_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkunScreen extends StatefulWidget {
  final String token;

  const AkunScreen({super.key, required this.token});

  @override
  State<AkunScreen> createState() => _AkunScreenState();
}

class _AkunScreenState extends State<AkunScreen> {
  late Future<Map<String, dynamic>?> _karyawanFuture;

  @override
  void initState() {
    super.initState();
    _karyawanFuture = ApiService.getKaryawanProfile(widget.token);
  }

  void _refreshData() {
    setState(() {
      _karyawanFuture = ApiService.getKaryawanProfile(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.teal.shade400;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _karyawanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data karyawan kosong"));
          }

          final kar = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // ============================
                // Header
                // ============================
                const Text(
                  "Profil Karyawan",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Foto profil / initial
                CircleAvatar(
                  radius: 45,
                  backgroundColor: accentColor,
                  child: Text(
                    (kar['kar_nama'] ?? '?')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  kar['kar_nama'] ?? '-',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditDataScreen(
                          token: widget.token,
                          karyawanData: kar,
                        ),
                      ),
                    );

                    // Refresh jika berhasil update
                    if (result == true) _refreshData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: accentColor,
                    elevation: 0,
                    side: BorderSide(color: accentColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Edit Profil"),
                ),

                const SizedBox(height: 30),

                // ============================
                // Informasi Pribadi
                // ============================
                _buildSection("Informasi Pribadi", [
                  _infoItem("Kode Karyawan", kar['kar_kode']),
                  _infoItem("NIK", kar['kar_nik']),
                  _infoItem("NIP", kar['kar_nip']),
                  _infoItem("Jenis Kelamin", kar['kar_jekel']),
                  _infoItem("Tempat Lahir", kar['kar_lahir_tmp']),
                  _infoItem("Tanggal Lahir", kar['kar_lahir_tgl']),
                  _infoItem("Alamat", kar['kar_alamat']),
                ]),

                const SizedBox(height: 16),

                // ============================
                // Informasi Kontak
                // ============================
                _buildSection("Informasi Kontak", [
                  _infoItem("Email Pribadi", kar['kar_email']),
                  _infoItem("Email Perusahaan", kar['kar_email_perusahaan']),
                  _infoItem("No HP", kar['kar_hp']),
                  _infoItem("No WA", kar['kar_wa']),
                  _infoItem("Telegram", kar['kar_telegram']),
                ]),

                const SizedBox(height: 16),

                // ============================
                // Informasi Administratif
                // ============================
                _buildSection("Informasi Administratif", [
                  _infoItem("Nomor Rekening", kar['kar_norek']),
                  _infoItem("No BPJS", kar['kar_nobpjs']),
                  _infoItem("No Jamsostek", kar['kar_nojamsostek']),
                  _infoItem("NPWP", kar['kar_npwp']),
                ]),

                const SizedBox(height: 28),

                // ============================
                // Tombol Logout
                // ============================
                OutlinedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('token');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================
  // Widget section container
  // ============================
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 3,
      shadowColor: Colors.teal.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.teal.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // ============================
  // Widget item label + value
  // ============================
  Widget _infoItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true ? value.toString() : "-",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
