import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurora_presence_flutter/screens/activity_screen.dart';
import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:aurora_presence_flutter/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'add_schedule.dart';
import 'details_schedule.dart';
import 'package:intl/intl.dart';

class PresensiScreen extends StatefulWidget {
  @override
  _PresensiScreenState createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late TabController _tabController;
  String searchQuery = '';
  List<Map<String, dynamic>> schedules = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ActivityScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PresensiScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Ubah jumlah tab menjadi 2
    _tabController = TabController(length: 2, vsync: this);
    _loadSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedSchedules = jsonEncode(schedules);
    await prefs.setString('schedules', encodedSchedules);
  }

  Future<void> _loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedSchedules = prefs.getString('schedules');
    if (encodedSchedules != null) {
      setState(() {
        schedules =
            List<Map<String, dynamic>>.from(jsonDecode(encodedSchedules));
      });
    } else {
      schedules = [
        {
          'title': 'Kunjungan Client',
          'date': DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
          'time': '09:00 AM - 11:00 PM',
          'location': 'PT Garuda Persada',
          'isHistory': true,
        },
      ];
    }
  }

  void _updateSchedule(Map<String, dynamic> updatedSchedule) {
    setState(() {
      int index =
          schedules.indexWhere((s) => s['title'] == updatedSchedule['title']);
      if (index != -1) {
        schedules[index] = updatedSchedule;
        if (updatedSchedule['isHistory']) {
          schedules.removeAt(index);
          schedules.insert(0, updatedSchedule);
        }
      }
      _saveSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'Presensi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: Color(0xFFF5F2F2),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'History'),
            ],
            labelColor: Colors.lightBlue,
            unselectedLabelColor: Color(0xFFA6A6A6),
            indicatorColor: Colors.lightBlue,
          ),
          Container(
            color: Color(0xFFF5F2F2),
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Schedule',
                hintStyle: TextStyle(color: Color(0xFFA6A6A6)),
                prefixIcon: Icon(Icons.search, color: Color(0xFFA6A6A6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleList(false, false),
                _buildScheduleList(true, false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddScheduleScreen(onScheduleAdded: (newSchedule) {
                setState(() {
                  schedules.insert(0, {
                    'title': newSchedule.title,
                    'date': newSchedule.dateStart,
                    'time': '${newSchedule.timeStart} - ${newSchedule.timeEnd}',
                    'location': newSchedule.office,
                    'isHistory': false,
                  });
                  _saveSchedules();
                });
              }),
            ),
          );
        },
        backgroundColor: Colors.lightBlue,
        icon: Icon(Icons.add_box_outlined, color: Colors.white),
        label: Text('Add Schedule', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.lightBlue,
        buttonBackgroundColor: Colors.lightBlue,
        height: 60,
        items: <Widget>[
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.manage_history_sharp, size: 30, color: Colors.white),
          Icon(Icons.assessment_outlined, size: 30, color: Colors.white),
          Icon(Icons.person_2_outlined, size: 30, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 200),
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildScheduleList(bool isHistory, bool isToday) {
    List<Map<String, dynamic>> filteredSchedules = schedules.where((schedule) {
      bool matchesSearch = schedule['title'].toLowerCase().contains(searchQuery);
      bool matchesStatus = schedule['isHistory'] == isHistory;
      return matchesSearch && matchesStatus;
    }).toList();

    return ListView.builder(
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        final schedule = filteredSchedules[index];
        return isHistory
            ? _buildScheduleCard(schedule)
            : Dismissible(
                key: Key(schedule['title']),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    schedule['isHistory'] = true;
                    _updateSchedule(schedule);
                  });
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Transform.rotate(
                      angle: -1.57,
                      child: Text(
                        'Success',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ),
                child: _buildScheduleCard(schedule),
              );
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFFE7E8FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              schedule['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text('Date: ${schedule['date']}',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text('Time: ${schedule['time']}',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Text('Location: ${schedule['location']}',
                    style: TextStyle(color: Colors.black)),
              ],
            ),
            if (schedule['isHistory']) ...[
              SizedBox(height: 8),
              Text(
                'Clock In: ${schedule['clockInTime'] ?? '-'}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Clock Out: ${schedule['clockOutTime'] ?? '-'}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsSchedule(
                        schedule: schedule,
                        onScheduleUpdate: _updateSchedule,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}