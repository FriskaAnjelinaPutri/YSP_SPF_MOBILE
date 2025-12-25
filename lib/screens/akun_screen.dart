import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'edit_data_screen.dart';

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
    const mainGreen = Color(0xFF064E3B);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profil Saya",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: mainGreen,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: _karyawanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: mainGreen),
            );
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

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: Container(
                    width: 420,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD1FAE5).withOpacity(0.95),
                          const Color(0xFFF0FDF4).withOpacity(0.75),
                          Colors.white.withOpacity(0.45),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: const Color(0xFF34D399).withOpacity(0.35),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF059669).withOpacity(0.25),
                          blurRadius: 34,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _glassAvatar(kar['kar_nama'] ?? '?'),

                        const SizedBox(height: 14),

                        Text(
                          kar['kar_nama'] ?? '-',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: mainGreen,
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
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

                              if (result == true) _refreshData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.white.withOpacity(0.65),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: const BorderSide(color: mainGreen),
                              ),
                            ),
                            child: const Text(
                              "Edit Profil",
                              style: TextStyle(
                                color: mainGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        _glassSection("Informasi Pribadi", [
                          _infoItem("Kode Karyawan", kar['kar_kode']),
                          _infoItem("NIK", kar['kar_nik']),
                          _infoItem("NIP", kar['kar_nip']),
                          _infoItem("Jenis Kelamin", kar['kar_jekel']),
                          _infoItem("Tempat Lahir", kar['kar_lahir_tmp']),
                          _infoItem("Tanggal Lahir", kar['kar_lahir_tgl']),
                          _infoItem("Alamat", kar['kar_alamat']),
                        ]),

                        const SizedBox(height: 20),

                        _glassSection("Informasi Kontak", [
                          _infoItem("Email Pribadi", kar['kar_email']),
                          _infoItem(
                              "Email Perusahaan", kar['kar_email_perusahaan']),
                          _infoItem("No HP", kar['kar_hp']),
                          _infoItem("No WA", kar['kar_wa']),
                          _infoItem("Telegram", kar['kar_telegram']),
                        ]),

                        const SizedBox(height: 20),

                        _glassSection("Informasi Administratif", [
                          _infoItem("Nomor Rekening", kar['kar_norek']),
                          _infoItem("No BPJS", kar['kar_nobpjs']),
                          _infoItem("No Jamsostek", kar['kar_nojamsostek']),
                          _infoItem("NPWP", kar['kar_npwp']),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= AVATAR =================
  Widget _glassAvatar(String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.35),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.4,
            ),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFDCFCE7),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 34,
                color: Color(0xFF064E3B),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassSection(String title, List<Widget> children) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.55),
                Colors.white.withOpacity(0.18),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF064E3B),
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true ? value.toString() : "-",
            ),
          ),
        ],
      ),
    );
  }
}
