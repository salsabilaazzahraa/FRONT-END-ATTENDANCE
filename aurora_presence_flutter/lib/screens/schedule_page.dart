import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:aurora_presence_flutter/screens/tambah_jadwal_screen.dart';
import 'package:flutter/material.dart';
import 'package:aurora_presence_flutter/models/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Schedule> schedules = [];
  List<TeamMember> teamMembers = [];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
    _loadTeamMembers();
  }

void _loadSchedules() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schedulesJsonStr = prefs.getString('schedules');
    
    if (schedulesJsonStr != null) {
      List<dynamic> schedulesJson = jsonDecode(schedulesJsonStr);
      setState(() {
        schedules = schedulesJson
            .map((json) => Schedule.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    }
  } catch (e) {
    print('Error loading schedules: $e');
    setState(() {
      schedules = [];
    });
  }
}

  void _saveSchedules() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> schedulesJson = 
        schedules.map((schedule) => schedule.toJson()).toList();
    String encodedSchedules = jsonEncode(schedulesJson);
    await prefs.setString('schedules', encodedSchedules);
  } catch (e) {
    print('Error saving schedules: $e');
  }
}

  void _saveTeamMembers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTeamMembers = teamMembers.map((member) {
      return jsonEncode({
        'name': member.name,
        'image': member.image,
      });
    }).toList();
    prefs.setStringList('teamMembers', encodedTeamMembers);
  }

  void _loadTeamMembers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedTeamMembers = prefs.getStringList('teamMembers');
    if (encodedTeamMembers != null) {
      setState(() {
        teamMembers = encodedTeamMembers.map((item) {
          final Map<String, dynamic> decodedItem = jsonDecode(item);
          return TeamMember(
            name: decodedItem['name'],
            image: decodedItem['image'],
          );
        }).toList();
      });
    }
  }

  void _deleteSchedule(int index) {
    setState(() {
      schedules.removeAt(index);
      _saveSchedules();
    });
  }

  void _navigateToTambahDataScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TambahDataScreen(
          onScheduleAdded: (newSchedule) {
            setState(() {
              schedules.add(newSchedule);
              _saveSchedules();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF00CEE8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  return _buildScheduleCard(schedules[index], index);
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToTambahDataScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00CEE8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Tambah Tugas',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildScheduleCard(Schedule schedule, int index) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.task_alt_outlined, color: Colors.green),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteSchedule(index),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Office: ${schedule.office}'),
          Text('Date: ${schedule.dateStart} - ${schedule.dateEnd}'),
          Text('Time: ${schedule.timeStart} - ${schedule.timeEnd}'),
          SizedBox(height: 8),
          Text(
            'Team Members:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          
          Row(
            children: schedule.teams.map((user) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(user.image),
                      radius: 25,
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.name,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
}