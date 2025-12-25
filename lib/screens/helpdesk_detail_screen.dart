import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/helpdesk_model.dart';

class HelpdeskDetailScreen extends StatelessWidget {
  final Helpdesk helpdesk;

  const HelpdeskDetailScreen({
    super.key,
    required this.helpdesk,
  });

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),

      // ================= APPBAR =================
      appBar: AppBar(
        title: const Text(
          "Detail Helpdesk",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: softGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGreen),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // ===== HEADER CARD =====
            _glassCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      helpdesk.judul,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: primaryGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          helpdesk.tanggalFormatted,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ===== DETAIL CARD =====
            _glassCard(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Kategori"),
                    _value(helpdesk.kategori),

                    const SizedBox(height: 16),
                    _label("Deskripsi"),
                    _descriptionBox(helpdesk.deskripsi),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENT =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: primaryGreen,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _value(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _descriptionBox(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentGreen.withOpacity(0.4),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _chip(String text, {bool isPriority = false}) {
    Color color;

    if (isPriority) {
      color = Colors.redAccent;
    } else {
      switch (text.toUpperCase()) {
        case 'OPEN':
          color = Colors.orange;
          break;
        case 'CLOSED':
          color = Colors.green;
          break;
        default:
          color = Colors.grey;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                softGreen.withOpacity(0.75),
                Colors.white.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: accentGreen.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryGreen.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
