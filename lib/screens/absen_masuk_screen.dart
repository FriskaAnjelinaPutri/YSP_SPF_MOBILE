import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:apk_absebsi/services/absensi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsenMasukScreen extends StatefulWidget {
  final Position? userPosition;
  const AbsenMasukScreen({super.key, this.userPosition});

  @override
  State<AbsenMasukScreen> createState() => _AbsenMasukScreenState();
}

class _AbsenMasukScreenState extends State<AbsenMasukScreen> {
  bool _isLoading = false;
  String? _selectedStatus;
  final TextEditingController _keteranganController = TextEditingController();
  final List<String> _statuses = ['Hadir', 'Terlambat', 'Izin', 'Sakit', 'Alpha'];

  static const primaryGreen = Color(0xFF064E3B);
  static const softGreen = Color(0xFFDCFCE7);
  static const accentGreen = Color(0xFF34D399);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitAbsen() async {
    if (widget.userPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi tidak ditemukan, tidak bisa absen.')),
      );
      return;
    }
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih status kehadiran.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final karKode = prefs.getString('karKode');

    if (token == null || karKode == null) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: Belum login atau data karyawan tidak ditemukan')),
        );
      }
      return;
    }

    final success = await AbsensiService.checkIn(
      token,
      karKode,
      widget.userPosition!.latitude,
      widget.userPosition!.longitude,
      _selectedStatus!,
      _keteranganController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Absen Masuk Berhasil!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal melakukan check-in')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F8EE),
      appBar: AppBar(
        title: const Text(
          'Absen Masuk',
          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGreen),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Lokasi Anda Saat Ini',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.userPosition != null)
                    _buildInteractiveMap()
                  else
                    _buildLocationError(),
                  const SizedBox(height: 24),
                  _buildStatusDropdown(),
                  const SizedBox(height: 16),
                  _glassInput("Keterangan (Opsional)", _keteranganController),
                  const SizedBox(height: 30),
                  _glassButton("SUBMIT ABSEN", _submitAbsen),
                ],
              ),
            ),
    );
  }

  Widget _buildInteractiveMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
                widget.userPosition!.latitude, widget.userPosition!.longitude),
            initialZoom: 17.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.yspspf.mobile', // Added user agent
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(widget.userPosition!.latitude,
                      widget.userPosition!.longitude),
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationError() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.withAlpha(128)),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Lokasi tidak tersedia dari Home Screen.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                softGreen.withAlpha(204),
                Colors.white.withAlpha(128),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentGreen.withAlpha(102)),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: _statuses.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Status Kehadiran',
              labelStyle: TextStyle(
                color: primaryGreen.withAlpha(179),
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
            dropdownColor: softGreen,
          ),
        ),
      ),
    );
  }

  Widget _glassInput(String label, TextEditingController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                softGreen.withAlpha(204),
                Colors.white.withAlpha(128),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentGreen.withAlpha(102)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
                color: primaryGreen, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: primaryGreen.withAlpha(179),
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: widget.userPosition != null ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: softGreen,
          elevation: 4,
          shadowColor: primaryGreen.withAlpha(89),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          disabledBackgroundColor: Colors.grey.withAlpha(128),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryGreen,
          ),
        ),
      ),
    );
  }
}
