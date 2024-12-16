import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'pengajuan_screen.dart';
import 'package:aurora_presence_flutter/models/riwayat.dart';

class RiwayatScreen extends StatefulWidget {
  final String tanggal;
  final String sampaiTanggal;
  final String deskripsi;
  final IconData icon;

  RiwayatScreen({
    required this.tanggal,
    required this.sampaiTanggal,
    required this.deskripsi,
    required this.icon,
  });

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final List<Riwayat> riwayat = [];

  @override
  void initState() {
    super.initState();
    loadRiwayat();
    addRiwayat(widget.tanggal, widget.sampaiTanggal, widget.deskripsi, widget.icon);
  }

  Future<void> loadRiwayat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedRiwayat = prefs.getString('riwayat');
    if (savedRiwayat != null) {
      setState(() {
        List<Map<String, dynamic>> loadedRiwayat =
            List<Map<String, dynamic>>.from(json.decode(savedRiwayat));
        riwayat.addAll(loadedRiwayat.map((item) => Riwayat.fromMap(item)).toList());
      });
    }
  }

  Future<void> saveRiwayat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('riwayat', json.encode(riwayat.map((item) => item.toMap()).toList()));
  }

  void addRiwayat(
      String tanggal, String sampaiTanggal, String deskripsi, IconData icon) {
    if (!tanggal.contains("Dummy") &&
        !sampaiTanggal.contains("Dummy") &&
        !deskripsi.contains("Dummy")) {
      setState(() {
        riwayat.add(Riwayat(
          tanggal: tanggal,
          sampaiTanggal: sampaiTanggal,
          deskripsi: deskripsi,
          icon: icon,
          iconColor: getIconColor(icon),
        ));
      });
      saveRiwayat();
    }
  }

  void deleteRiwayat(int index) {
    setState(() {
      riwayat.removeAt(index);
    });
    saveRiwayat();
  }

  String getTitle(IconData icon) {
    if (icon == Icons.assignment_outlined) {
      return "Izin";
    } else if (icon == Icons.sick) {
      return "Sakit";
    } else if (icon == Icons.work_history_outlined) {
      return "Dinas";
    } else {
      return "Riwayat";
    }
  }

  Color getIconColor(IconData icon) {
    if (icon == Icons.assignment_outlined) {
      return Colors.green;
    } else if (icon == Icons.sick) {
      return Colors.red;
    } else if (icon == Icons.work_history_outlined) {
      return Colors.blue;
    } else {
      return Colors.blue; // default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00CEE8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PengajuanScreen()),
            );
          },
        ),
        title: Text(
          "Riwayat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF5F2F2),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: riwayat.length,
          itemBuilder: (context, index) {
            final item = riwayat[index];
            return buildRiwayatItem(item, index);
          },
        ),
      ),
    );
  }

  Widget buildRiwayatItem(Riwayat item, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(item.icon, color: item.iconColor, size: 40),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getTitle(item.icon),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Tanggal Izin:  ${item.tanggal}",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Sampai Tanggal:  ${item.sampaiTanggal}",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Deskripsi: ${item.deskripsi}",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 28),
              onPressed: () => deleteRiwayat(index),
            ),
          ],
        ),
      ),
    );
  }
}
