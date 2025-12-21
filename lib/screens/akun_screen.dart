import 'dart:ui';
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
    const mainGreen = Color(0xFF14532D);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: _karyawanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: mainGreen));
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
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // ============================
                // HEADER GLASS
                // ============================
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.60),
                            Colors.white.withOpacity(0.20),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.3,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Glass Avatar
                          _glassAvatar(kar['kar_nama'] ?? '?'),

                          const SizedBox(height: 12),

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
                                backgroundColor: Colors.white.withOpacity(0.65),
                                elevation: 0,
                                shadowColor: Colors.green.withOpacity(0.25),
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
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ============================
                // SECTION GLASS CARDS
                // ============================
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
                  _infoItem("Email Perusahaan", kar['kar_email_perusahaan']),
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

                const SizedBox(height: 26),

                // ============================
                // LOGOUT GLASS BUTTON
                // ============================
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('token');
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(160, 48),
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade700),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),
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
  // GLASS AVATAR
  // ============================
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
            backgroundColor: Colors.green.withOpacity(0.22),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 34,
                color: Color(0xFF14532D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // GLASS SECTION CARD
  // ============================
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // INFO ITEM
  // ============================
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
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true ? value.toString() : "-",
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
