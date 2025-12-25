import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/helpdesk_model.dart';
import '../services/helpdesk_service.dart';
import 'helpdesk_add_screen.dart';
import 'helpdesk_detail_screen.dart';

class HelpdeskListScreen extends StatefulWidget {
  final String token;

  const HelpdeskListScreen({
    super.key,
    required this.token,
  });

  @override
  State<HelpdeskListScreen> createState() => _HelpdeskListScreenState();
}

class _HelpdeskListScreenState extends State<HelpdeskListScreen> {
  late Future<List<Helpdesk>> helpdeskList;

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
    helpdeskList = _fetchHelpdesk();
  }

  Future<List<Helpdesk>> _fetchHelpdesk() async {
    final data = await HelpdeskService.getAllHelpdesk(widget.token);
    return data.map((e) => Helpdesk.fromJson(e)).toList();
  }

  Future<void> _refresh() async {
    setState(() => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      // =============================
      //        GLASS APPBAR
      // =============================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: AppBar(
              backgroundColor: softGreen.withOpacity(0.65),
              elevation: 0,
              leading: const SizedBox(),
              title: const Text(
                "Helpdesk",
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
      //        FAB GLASS
      // =============================
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: softGreen.withOpacity(0.65),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HelpdeskAddScreen(token: widget.token),
                ),
              );
              if (result == true) _refresh();
            },
            child: const Icon(Icons.add, color: primaryGreen),
          ),
        ),
      ),

      // =============================
      //            BODY
      // =============================
      body: FutureBuilder<List<Helpdesk>>(
        future: helpdeskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Gagal memuat helpdesk: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada tiket helpdesk",
                style: TextStyle(
                  fontSize: 16,
                  color: primaryGreen,
                ),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),

                    // ICON KIRI
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        color: primaryGreen,
                      ),
                    ),

                    // TITLE
                    title: Text(
                      item.judul,
                      style: const TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    // SUBTITLE
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kategori: ${item.kategori}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Tanggal: ${item.tanggalFormatted}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // STATUS
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(item.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.status.toUpperCase(),
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
                          builder: (_) => HelpdeskDetailScreen(
                            helpdesk: item,
                          ),
                        ),
                      ).then((refresh) {
                        if (refresh == true) _refresh();
                      });
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
  // GLASS CARD STYLE (SAMA DENGAN LEMBUR)
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
  // STATUS COLOR
  // =====================================================
  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "OPEN":
        return Colors.orange.shade700;
      case "CLOSED":
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
