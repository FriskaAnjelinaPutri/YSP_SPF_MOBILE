import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/cuti_service.dart';
import 'cuti_add_screen.dart';
import 'cuti_detail_screen.dart';

class CutiListScreen extends StatefulWidget {
  final String token;
  final String karKode;

  const CutiListScreen({
    super.key,
    required this.token,
    required this.karKode,
  });

  @override
  State<CutiListScreen> createState() => _CutiListScreenState();
}

class _CutiListScreenState extends State<CutiListScreen> {
  late Future<List<dynamic>> cuti;

  // WARNA SESUAI DASHBOARD
  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    cuti = CutiService.getAllCuti(widget.token, widget.karKode);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadData();
    });
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
              // Hapus leading karena panah tidak dibutuhkan
              leading: null,
              title: const Text(
                "Data Cuti",
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

      // =============================
      //      FAB GLASS STYLE
      // =============================
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton(
            backgroundColor: softGreen.withOpacity(0.65),
            elevation: 4,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CutiAddScreen(
                    token: widget.token,
                    karKode: widget.karKode,
                  ),
                ),
              );

              if (result == true) _refresh();
            },
            child: const Icon(Icons.add, color: primaryGreen),
          ),
        ),
      ),

      // =============================
      //      BODY
      // =============================
      body: FutureBuilder<List<dynamic>>(
        future: cuti,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Gagal memuat data cuti: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada pengajuan cuti",
                style: TextStyle(fontSize: 16, color: primaryGreen),
              ),
            );
          }

          final data = snapshot.data!;

          return RefreshIndicator(
            color: primaryGreen,
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return _glassCard(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.calendar_month, color: primaryGreen),
                    ),

                    title: Text(
                      item["alasan"] ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: primaryGreen,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Text(
                      "${item["tanggal_mulai"] ?? "-"} → ${item["tanggal_selesai"] ?? "-"}",
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),

                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(item["status"]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item["status"] ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CutiDetailScreen(
                            token: widget.token,
                            karKode: widget.karKode,
                            cuti: item,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // =====================================================
  // GLASS CARD COMPONENT (MATCHING DASHBOARD STYLE)
  // =====================================================
  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  softGreen.withOpacity(0.75),
                  Colors.white.withOpacity(0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: accentGreen.withOpacity(0.35),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // WARNA STATUS CUTI
  // =====================================================
  Color _statusColor(String? status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
