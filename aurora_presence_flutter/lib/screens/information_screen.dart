import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  // Default values for pengumuman and faq
  final List<String> pengumuman = [
    'Kantor tutup pada tanggal 17 Agustus untuk Hari Kemerdekaan.',
    'Workshop internal tentang keamanan siber akan diadakan pada 1 September.',
  ];
  
  final List<Map<String, String>> faq = [
    {'question': 'Bagaimana cara reset password email kantor?', 'answer': 'Silakan hubungi tim IT di it.support@idsteknologi.co.id.'},
    {'question': 'Apa saja fasilitas yang disediakan di kantor?', 'answer': 'Kami menyediakan kantin, ruang olahraga, dan ruang kesehatan.'},
    {'question': 'Bagaimana cara mengajukan cuti?', 'answer': 'Pengajuan cuti bisa dilakukan melalui portal HR di intranet perusahaan.'},
  ];
  
  final String jamKerja = 'Senin - Jumat: 09:00 - 17:00\nSabtu, Minggu & Hari Libur: Tutup';
  
  final List<Map<String, String>> kontak = [
    {'type': 'Telepon', 'detail': '+62 21 1234 5678'},
    {'type': 'Email', 'detail': 'contact@idsteknologi.co.id'},
    {'type': 'Alamat', 'detail': 'Jl. Legenda Wisata Boulevard'},
  ];

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
          "Informasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionHeader('Pengumuman Penting', Icons.announcement, context),
            SizedBox(height: 8),
            _buildBoxedContent(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: pengumuman.map((item) {
                  return ListTile(
                    title: Text(item),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            _buildSectionHeader('Jam Kerja', Icons.access_time, context),
            SizedBox(height: 8),
            _buildBoxedContent(
              context,
              Text(jamKerja),
            ),
            SizedBox(height: 16),

            _buildSectionHeader('FAQ', Icons.question_answer, context),
            SizedBox(height: 8),
            _buildBoxedContent(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: faq.map((item) {
                  return ListTile(
                    title: Text('Q: ${item['question']}'),
                    subtitle: Text('A: ${item['answer']}'),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            _buildSectionHeader('Hubungi Kami', Icons.contact_phone, context),
            SizedBox(height: 8),
            _buildBoxedContent(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: kontak.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('${item['type']}: ${item['detail']}'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF00CEE8)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBoxedContent(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      padding: EdgeInsets.all(12),
      child: child,
    );
  }
}
