import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationScreen extends StatefulWidget {
  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  // Default values for pengumuman and faq
  List<String> pengumuman = [
    'Kantor tutup pada tanggal 17 Agustus untuk Hari Kemerdekaan.',
    'Workshop internal tentang keamanan siber akan diadakan pada 1 September.',
  ];
  
  List<Map<String, String>> faq = [
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
  
  final List<Map<String, String>> informasiTambahan = [
    {
      'image': 'images/libur.jpg',
      'description': 'Hari libur tahun baru 2024 diundur ke bulan September',
      'date': '1 Agustus 2024',
    },
    {
      'image': 'images/gaji.jpg',
      'description': 'Gajian Bulan ini dipercepat lima hari',
      'date': '15 Juli 2024',
    },
    {
      'image': 'images/liburbersama.jpg',
      'description': 'Agenda Libur Bersama',
      'date': '9 September 2024',
    },
    {
      'image': 'images/profil.png',
      'description': 'Selamat Ulang Tahun, Michi-chan!',
      'date': '1 Agustus 2024',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _savePengumuman() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('pengumuman', pengumuman);
  }

  Future<void> _loadPengumuman() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? loadedPengumuman = prefs.getStringList('pengumuman');
    if (loadedPengumuman != null) {
      setState(() {
        pengumuman = loadedPengumuman;
      });
    }
  }

  Future<void> _saveFaq() async {
    final prefs = await SharedPreferences.getInstance();
    final String faqString = faq.map((e) => '${e['question']}|${e['answer']}').join(';');
    await prefs.setString('faq', faqString);
  }

  Future<void> _loadFaq() async {
    final prefs = await SharedPreferences.getInstance();
    final String? faqString = prefs.getString('faq');
    if (faqString != null) {
      setState(() {
        faq = faqString.split(';').map((item) {
          final parts = item.split('|');
          return {
            'question': parts[0],
            'answer': parts[1],
          };
        }).toList();
      });
    }
  }

  Future<void> _loadData() async {
    await _loadPengumuman();
    await _loadFaq();
  }

  void _editPengumuman(int index) {
    TextEditingController controller = TextEditingController(text: pengumuman[index]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Pengumuman'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  pengumuman[index] = controller.text;
                });
                _savePengumuman(); // Save changes
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _addPengumuman() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Pengumuman'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  pengumuman.add(controller.text);
                });
                _savePengumuman(); // Save changes
                Navigator.pop(context);
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _removePengumuman(int index) {
    setState(() {
      pengumuman.removeAt(index);
    });
    _savePengumuman(); // Save changes
  }

  void _editFaq(int index) {
    TextEditingController questionController = TextEditingController(text: faq[index]['question']);
    TextEditingController answerController = TextEditingController(text: faq[index]['answer']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit FAQ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Jawaban'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  faq[index] = {
                    'question': questionController.text,
                    'answer': answerController.text,
                  };
                });
                _saveFaq(); // Save changes
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _addFaq() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah FAQ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: 'Jawaban'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  faq.add({
                    'question': questionController.text,
                    'answer': answerController.text,
                  });
                });
                _saveFaq(); // Save changes
                Navigator.pop(context);
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _removeFaq(int index) {
    setState(() {
      faq.removeAt(index);
    });
    _saveFaq(); // Save changes
  }

  Widget _buildInformasiTambahan(BuildContext context) {
    return Column(
      children: informasiTambahan.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200, // Increase height of image
                  child: Image.asset(
                    item['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['description']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item['date']!,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
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
                children: pengumuman.asMap().entries.map((entry) {
                  int index = entry.key;
                  String item = entry.value;
                  return ListTile(
                    title: Text(item),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editPengumuman(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removePengumuman(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            TextButton(
              onPressed: _addPengumuman,
              child: Text('Tambah Pengumuman'),
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
                children: faq.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, String> item = entry.value;
                  return ListTile(
                    title: Text('Q: ${item['question']}'),
                    subtitle: Text('A: ${item['answer']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editFaq(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeFaq(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            TextButton(
              onPressed: _addFaq,
              child: Text('Tambah FAQ'),
            ),
            SizedBox(height: 16),

            _buildSectionHeader('Informasi Tambahan', Icons.info, context),
            SizedBox(height: 8),
            _buildInformasiTambahan(context),
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
      child:child,
);
}
}
