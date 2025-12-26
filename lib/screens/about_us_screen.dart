import 'dart:ui';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF064E3B);
    const softGreen = Color(0xFFDCFCE7);
    const accentGreen = Color(0xFF34D399);

    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "About Us",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: softGreen.withOpacity(0.4),
                        child: Icon(
                          Icons.info_outline,
                          size: 40,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Tentang Kami",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Rumah Sakit Semen Padang sebagai salah satu institusi "
                          "pelayanan kesehatan memiliki jumlah karyawan yang cukup "
                          "besar dengan variasi jabatan dan pola kerja. Berdasarkan "
                          "hasil observasi dan telaah dokumentasi yang dilakukan, "
                          "sistem absensi dan pengelolaan administrasi kepegawaian "
                          "sebelumnya masih berjalan secara terpisah dan sebagian "
                          "mengandalkan proses manual atau semi komputerisasi. "
                          "Proses absensi karyawan dilakukan tanpa integrasi langsung "
                          "dengan data lembur, cuti, dan rekap kehadiran, sehingga "
                          "memerlukan pencatatan ulang dan verifikasi manual oleh bagian terkait.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Visi & Misi",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Visi: Menjadi Rumah Sakit Umum pilihan utama yang menghadirkan layanan prima di Sumatera Tahun 2030.\n\n"
                          "Misi:\n"
                          "- Kami adalah penyedia layanan kesehatan yang di kelola oleh human capital berjiwa muda dan adaptif dengan mengedepankan inovasi teknologi terkini.\n"
                          "- Kami memberikan pengalaman terbaik bagi pelanggan (customer experience) dengan mengutamakan mutu dan keselamatan.\n"
                          "- ami menciptakan kebahagiaan dalam setiap aktivitas untuk peningkatan derajat kesehatan masyarakat.",
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Kontak Kami",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Email: info@semenpadanghospital.co.id\n"
                          "Telepon: +0751 777 888\n"
                          "Alamat: Jl. Bypass Km 7 Pisang, Padang – Indonesia",
                      style: TextStyle(fontSize: 16, height: 1.5),
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
}
