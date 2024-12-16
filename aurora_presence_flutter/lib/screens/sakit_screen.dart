import 'package:aurora_presence_flutter/screens/pengajuan_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'riwayat_screen.dart';

class SakitScreen extends StatelessWidget {
  final TextEditingController _tanggalIzinController = TextEditingController();
  final TextEditingController _sampaiTanggalController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

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
          "Sakit",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFF5F2F2),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              "Form Perizinan Sakit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Lengkapi data pada form untuk mengajukan perizinan",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildFormField("Tanggal izin", context, _tanggalIzinController),
            SizedBox(height: 16),
            _buildFormField("Sampai Tanggal", context, _sampaiTanggalController),
            SizedBox(height: 16),
            _buildFormField("Deskripsi", context, _deskripsiController, isDescription: true),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RiwayatScreen(
                        tanggal: _tanggalIzinController.text,
                        sampaiTanggal: _sampaiTanggalController.text,
                        deskripsi: _deskripsiController.text,
                        icon: Icons.sick,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00CEE8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, BuildContext context, TextEditingController? controller, {bool isDescription = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: false,
          maxLines: isDescription ? 4 : 1,
          decoration: InputDecoration(
            hintText: isDescription ? "Deskripsi keterangan" : "Pilih tanggal",
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: isDescription
                ? null
                : IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat('dd-MMM-yyyy').format(pickedDate);
                        controller?.text = formattedDate;
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
