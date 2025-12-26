import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:apk_absebsi/services/absensi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsenKeluarScreen extends StatefulWidget {
  final Position? userPosition;
  const AbsenKeluarScreen({super.key, this.userPosition});

  @override
  State<AbsenKeluarScreen> createState() => _AbsenKeluarScreenState();
}

class _AbsenKeluarScreenState extends State<AbsenKeluarScreen> {
  bool _isLoading = false;

  static const primaryRed = Color(0xFF7F1D1D);
  static const softRed = Color(0xFFFEE2E2);

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

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
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

    final success = await AbsensiService.checkOut(
      token,
      widget.userPosition!.latitude,
      widget.userPosition!.longitude,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Absen Keluar Berhasil!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal melakukan check-out')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF2F2),
      appBar: AppBar(
        title: const Text(
          'Absen Keluar',
          style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryRed),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryRed))
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
                      color: primaryRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.userPosition != null)
                    _buildInteractiveMap()
                  else
                    _buildLocationError(),
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
                    color: primaryRed,
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
            style: TextStyle(color: primaryRed, fontSize: 16),
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
          backgroundColor: softRed,
          elevation: 4,
          shadowColor: primaryRed.withAlpha(89),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          disabledBackgroundColor: Colors.grey.withAlpha(128),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
