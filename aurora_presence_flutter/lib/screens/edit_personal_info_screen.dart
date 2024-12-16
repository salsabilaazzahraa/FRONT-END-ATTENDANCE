import 'package:flutter/material.dart';
import 'package:aurora_presence_flutter/models/personal_info.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  final PersonalInfo personalInfo;

  EditPersonalInfoScreen({required this.personalInfo});

  @override
  _EditPersonalInfoScreenState createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _employeeIDController;
  late TextEditingController _departmentController;
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.personalInfo.name);
    _phoneNumberController =
        TextEditingController(text: widget.personalInfo.phoneNumber);
    _emailController = TextEditingController(text: widget.personalInfo.email);
    _dobController = TextEditingController(text: widget.personalInfo.dob);
    _genderController = TextEditingController(text: widget.personalInfo.gender);
    _addressController =
        TextEditingController(text: widget.personalInfo.address);
    _emergencyPhoneController =
        TextEditingController(text: widget.personalInfo.emergencyPhone);
    _employeeIDController =
        TextEditingController(text: widget.personalInfo.employeeID);
    _departmentController =
        TextEditingController(text: widget.personalInfo.department);
    _positionController =
        TextEditingController(text: widget.personalInfo.position);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dobController.text.isEmpty
          ? DateTime.now()
          : DateFormat('dd/MM/yyyy').parse(_dobController.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Personal Information',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Color(0xFF00CEE8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField('Name', _nameController),
            buildTextField('Phone Number', _phoneNumberController),
            buildTextField('Email', _emailController),
            buildDateField(context),
            buildTextField('Gender', _genderController),
            buildTextField('Address', _addressController),
            buildTextField('Emergency Phone', _emergencyPhoneController),
            buildTextField('Employee ID', _employeeIDController),
            buildTextField('Department', _departmentController),
            buildTextField('Position', _positionController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedInfo = PersonalInfo(
                  name: _nameController.text,
                  phoneNumber: _phoneNumberController.text,
                  email: _emailController.text,
                  dob: _dobController.text,
                  gender: _genderController.text,
                  address: _addressController.text,
                  emergencyPhone: _emergencyPhoneController.text,
                  employeeID: _employeeIDController.text,
                  department: _departmentController.text,
                  position: _positionController.text,
                );
                Navigator.pop(context, updatedInfo);
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Colors.white, // Menambahkan warna putih untuk teks
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00CEE8),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: GoogleFonts.poppins(),
      ),
    );
  }

  Widget buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
        style: GoogleFonts.poppins(),
        onTap: () => _selectDate(context),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _emergencyPhoneController.dispose();
    _employeeIDController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }
}
