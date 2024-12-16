import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_personal_info_screen.dart';
import 'package:aurora_presence_flutter/models/personal_info.dart';

class PersonalScreen extends StatefulWidget {
  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  PersonalInfo? personalInfo; // Changed from late to nullable

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Check if widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        personalInfo = PersonalInfo(
          name: prefs.getString('name') ?? "Indah Sinurat",
          phoneNumber: prefs.getString('phoneNumber') ?? "1321589",
          email: prefs.getString('email') ?? "tya@gmail.com",
          dob: prefs.getString('dob') ?? "01/05/1999",
          gender: prefs.getString('gender') ?? "Perempuan",
          address: prefs.getString('address') ?? "Blok M",
          emergencyPhone: prefs.getString('emergencyPhone') ?? "5642875",
          employeeID: prefs.getString('employeeID') ?? "E12345",
          department: prefs.getString('department') ?? "IT",
          position: prefs.getString('position') ?? "Software Engineer",
        );
      });
    }
  }

  Future<void> _savePersonalInfo(PersonalInfo updatedInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> infoMap = updatedInfo.toMap();
    
    for (String key in infoMap.keys) {
      await prefs.setString(key, infoMap[key]);
    }

    if (mounted) {
      setState(() {
        personalInfo = updatedInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while data is being loaded
    if (personalInfo == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00CEE8),
          ),
        ),
      );
    }

    // Main UI after data is loaded
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF00CEE8),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              title: Center(
                child: Text(
                  "Personal Information",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPersonalInfoScreen(
                            personalInfo: personalInfo!,
                          ),
                        ),
                      );

                      if (result != null && result is PersonalInfo) {
                        await _savePersonalInfo(result);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 15,
            right: 15,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "General Info",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildInfoRow("Name", personalInfo!.name),
                    buildInfoRow("Phone Number", personalInfo!.phoneNumber),
                    buildInfoRow("Email", personalInfo!.email),
                    buildInfoRow("Date of Birth", personalInfo!.dob),
                    buildInfoRow("Gender", personalInfo!.gender),
                    buildInfoRow("Address", personalInfo!.address),
                    buildInfoRow("Emergency Phone", personalInfo!.emergencyPhone),
                    buildInfoRow("Employee ID", personalInfo!.employeeID),
                    buildInfoRow("Department", personalInfo!.department),
                    buildInfoRow("Position", personalInfo!.position),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFA6A6A6),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}