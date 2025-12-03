import 'package:apk_absebsi/screens/lembur_add_screen.dart';
import 'package:flutter/material.dart';
import '../services/lembur_service.dart';
import 'lembur_detail_screen.dart';

class LemburListScreen extends StatefulWidget {
  final String token;

  const LemburListScreen({
    super.key,
    required this.token,
  });

  @override
  State<LemburListScreen> createState() => _LemburListScreenState();
}

class _LemburListScreenState extends State<LemburListScreen> {
  late Future<List<dynamic>> lemburList;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    lemburList = LemburService.getRiwayat(token: widget.token);
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
        title: const Text("Riwayat Lembur"),
        backgroundColor: Colors.orange,
      ),

      // =============================
      // TOMBOL TAMBAH LEMBUR
      // =============================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LemburAddScreen(
                token: widget.token,
              ),
            ),
          );

          if (result == true) {
            _refresh(); // refresh setelah tambah
          }
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder(
        future: lemburList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Gagal memuat data lembur: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("Belum ada riwayat lembur",
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
                    contentPadding: const EdgeInsets.all(15),

                    leading: const Icon(
                      Icons.access_time_filled,
                      color: Colors.orange,
                    ),

                    title: Text(
                      "Tanggal: ${item["tanggal"] ?? "-"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),

                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jam: ${item["jam_mulai"]} - ${item["jam_selesai"]}",
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            "Alasan: ${item["alasan"]}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(item["status"]),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item["status"],
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
                      ),
                    ),

                    // Buka halaman detail
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LemburDetailScreen(
                            token: widget.token,
                            lembur: item,
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

  // Warna status Approved/Rejected/Pending
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
