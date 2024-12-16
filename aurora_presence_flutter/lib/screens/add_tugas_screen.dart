import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTugasScreen extends StatefulWidget {
  @override
  _AddTugasScreenState createState() => _AddTugasScreenState();
}

class _AddTugasScreenState extends State<AddTugasScreen> {
  final TextEditingController _namaTugasController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void _addTugas() {
    if (_namaTugasController.text.isNotEmpty && _selectedDate != null) {
      Navigator.pop(context, {
        "title": _namaTugasController.text,
        "date": DateFormat('dd-MMMM-yyyy').format(_selectedDate!),
      });
    }
  }

  Widget _buildFormField({
    required String labelText,
    required TextEditingController controller,
    Widget? suffixIcon,
    bool readOnly = false,
    GestureTapCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar untuk mengatur lebar tombol
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00CEE8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Tambah Tugas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormField(
              labelText: 'Nama Tugas',
              controller: _namaTugasController,
            ),
            SizedBox(height: 16),
            _buildFormField(
              labelText: _selectedDate == null
                  ? 'Target Selesai'
                  : DateFormat('dd-MMMM-yyyy').format(_selectedDate!),
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : DateFormat('dd-MMMM-yyyy').format(_selectedDate!),
              ),
              readOnly: true,
              suffixIcon: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),
            _buildFormField(
              labelText: 'Deskripsi',
              controller: _deskripsiController,
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: _addTugas,
                child: Container(
                  width: screenWidth * 0.9, // Lebar 90% dari lebar layar
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF00CEE8),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // perubahan posisi bayangan
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Tambah Tugas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
