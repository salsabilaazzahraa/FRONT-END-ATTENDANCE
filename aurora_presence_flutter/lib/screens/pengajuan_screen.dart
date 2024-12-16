import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'izin_screen.dart';
import 'sakit_screen.dart' as sakit;
import 'dinas_screen.dart' as dinas;
import 'riwayat_screen.dart';

class PengajuanScreen extends StatelessWidget {
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
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text(
          "Pengajuan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('images/ilustration.png', width: 250, height: 200),
              SizedBox(height: 16),
              Text(
                "Pilih Pengajuan",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                "Silahkan pilih pengajuan yang ingin anda ajukan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10, width: 5,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => sakit.SakitScreen()),
                        );
                      },
                      child: _buildGridItem('images/sakit.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => dinas.DinasScreen()),
                        );
                      },
                      child: _buildGridItem('images/dinas.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IzinScreen()),
                        );
                      },
                      child: _buildGridItem('images/izin.png'),
                    ),
                    GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RiwayatScreen(
          tanggal: 'Dummy Tanggal Izin',
          sampaiTanggal: 'Dummy Sampai Tanggal',
          deskripsi: 'Dummy Deskripsi',
          icon: Icons.history,
        ),
      ),
    );
  },
  child: _buildGridItem('images/riwayat.png'),
),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String imagePath) {
    return Center(
      child: Image.asset(imagePath, width: 140, height: 140),
    );
  }
}
