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
      appBar: AppBar(
        title: const Text("Data Cuti"),
        backgroundColor: Colors.teal,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
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
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<dynamic>>(
        future: cuti,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                  "Gagal memuat data cuti: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red),
                ));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("Belum ada pengajuan cuti",
                    style: TextStyle(fontSize: 16)));
          }

          final data = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month, color: Colors.teal),
                    title: Text(item["alasan"] ?? "-"),
                    subtitle: Text(
                      "${item["tanggal_mulai"] ?? "-"} → ${item["tanggal_selesai"] ?? "-"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(item["status"]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item["status"] ?? "",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
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
  //  WARNA STATUS CUTI
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
