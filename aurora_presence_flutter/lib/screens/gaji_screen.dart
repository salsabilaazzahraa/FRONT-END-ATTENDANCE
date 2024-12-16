import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GajiScreen extends StatefulWidget {
  @override
  _GajiScreenState createState() => _GajiScreenState();
}

class _GajiScreenState extends State<GajiScreen> {
  bool isNominalHidden = false;
  Map<String, List<Map<String, String>>> slipGajiMap = {};

  @override
  void initState() {
    super.initState();
    _loadSlipGajiList();
  }

  Future<void> _loadSlipGajiList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? slipGajiData = prefs.getString('slipGajiMap');
    if (slipGajiData != null) {
      setState(() {
        slipGajiMap = Map<String, List<Map<String, String>>>.from(
          json.decode(slipGajiData).map((key, value) => MapEntry(
              key, List<Map<String, String>>.from(value.map((item) => Map<String, String>.from(item))))),
        );
      });
    }
  }

  Future<void> _saveSlipGajiList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String slipGajiData = json.encode(slipGajiMap);
    prefs.setString('slipGajiMap', slipGajiData);
  }

  void toggleNominalVisibility() {
    setState(() {
      isNominalHidden = !isNominalHidden;
    });
  }

  void downloadSlipGaji(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Mencegah dialog ditutup dengan tap di luar
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              // Icon Success
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 50,
              ),
              SizedBox(height: 16),
              Text(
                'Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Slip Gaji berhasil diunduh',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00CEE8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tutup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void addSlipGaji(BuildContext context) {
    String bulan = '';
    String nominal = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Slip Gaji'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Bulan & Tahun (Misalnya: Januari 2023)'),
                onChanged: (value) {
                  bulan = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Nominal'),
                onChanged: (value) {
                  nominal = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () {
                String tahun = bulan.split(' ').last;
                setState(() {
                  if (!slipGajiMap.containsKey(tahun)) {
                    slipGajiMap[tahun] = [];
                  }
                  slipGajiMap[tahun]!.add({'bulan': bulan, 'nominal': nominal});
                });
                _saveSlipGajiList(); // Simpan setelah menambahkan data
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> sortedYears = slipGajiMap.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sortir tahun dari yang terbaru ke yang terlama

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00CEE8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Slip Gaji',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined, color: Colors.white),
            onPressed: () => addSlipGaji(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sortedYears.map((tahun) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tahun,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...slipGajiMap[tahun]!.map((slip) {
                    return ListTile(
                      leading: Image.asset('images/pdf.png'),
                      title: Text(slip['bulan']!),
                      subtitle: Text(
                        isNominalHidden ? 'Nominal disembunyikan' : slip['nominal']!,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isNominalHidden
                                  ? Icons.visibility_off
                                  : Icons.remove_red_eye,
                            ),
                            onPressed: toggleNominalVisibility,
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => downloadSlipGaji(context),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 16), // Berikan jarak antar tahun
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
