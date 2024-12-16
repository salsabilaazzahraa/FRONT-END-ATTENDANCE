import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:aurora_presence_flutter/screens/presensi_screen.dart';
import 'package:aurora_presence_flutter/screens/profile_screen.dart';
import 'package:aurora_presence_flutter/models/activity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 1;
  
  String _getIndonesianMonth(DateTime date) {
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 
      'Mei', 'Juni', 'Juli', 'Agustus',
      'September', 'Oktober', 'November', 'Desember'
    ];
    return months[date.month - 1];
  }

  final List<Activity> allActivities = [
    // Januari 2024
    Activity(
        date: DateTime(2024, 1, 31),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 1, 30),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 1, 29),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    
    // Februari 2024
    Activity(
        date: DateTime(2024, 2, 28),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 2, 27),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 2, 26),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Maret 2024
    Activity(
        date: DateTime(2024, 3, 29),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 3, 28),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 3, 27),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // April 2024
    Activity(
        date: DateTime(2024, 4, 30),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 4, 29),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 4, 26),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Mei 2024
    Activity(
        date: DateTime(2024, 5, 31),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 5, 30),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 5, 29),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Juni 2024 (existing)
    Activity(
        date: DateTime(2024, 6, 28),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 6, 27),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 6, 26),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Juli 2024 (existing)
    Activity(
        date: DateTime(2024, 7, 31),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 7, 30),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 7, 29),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Agustus 2024 (existing)
    Activity(
        date: DateTime(2024, 8, 6),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM',
        isToday: true),
    Activity(
        date: DateTime(2024, 8, 5),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 8, 2),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // September 2024
    Activity(
        date: DateTime(2024, 9, 30),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 9, 27),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 9, 26),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Oktober 2024
    Activity(
        date: DateTime(2024, 10, 31),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 10, 30),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 10, 29),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // November 2024
    Activity(
        date: DateTime(2024, 11, 29),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 11, 28),
        day: 'Kamis',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 11, 27),
        day: 'Rabu',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),

    // Desember 2024
    Activity(
        date: DateTime(2024, 12, 31),
        day: 'Selasa',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 12, 30),
        day: 'Senin',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
    Activity(
        date: DateTime(2024, 12, 27),
        day: 'Jumat',
        clockIn: '09:00 AM',
        breakStart: '12:00 PM',
        breakOut: '13:00 PM',
        clockOut: '17:00 PM'),
  ];

  String selectedFilter = 'Bulanan';
  DateTime currentMonth = DateTime.now();
  DateTime? selectedDate;
  List<Activity> activities = [];

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
    _filterActivities();
  }

  void _filterActivities() {
    setState(() {
      if (selectedFilter == 'Harian') {
        activities = allActivities.where((activity) {
          return activity.date.year == DateTime.now().year &&
              activity.date.month == DateTime.now().month &&
              activity.date.day == DateTime.now().day;
        }).toList();
      } else if (selectedFilter == 'Mingguan') {
        DateTime startOfWeek =
            DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
        DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
        activities = allActivities.where((activity) {
          return activity.date
                  .isAfter(startOfWeek.subtract(Duration(days: 1))) &&
              activity.date.isBefore(endOfWeek.add(Duration(days: 1)));
        }).toList();
      } else if (selectedFilter == 'Bulanan') {
        activities = allActivities.where((activity) {
          return activity.date.month == currentMonth.month &&
              activity.date.year == currentMonth.year;
        }).toList();
      } else if (selectedFilter == 'Pilih Tanggal' && selectedDate != null) {
        activities = allActivities.where((activity) {
          return activity.date.year == selectedDate!.year &&
              activity.date.month == selectedDate!.month &&
              activity.date.day == selectedDate!.day;
        }).toList();
      } else {
        activities = allActivities;
      }
    });
  }

  void _onFilterChanged(String filter) async {
    if (filter == 'Pilih Tanggal') {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedFilter = filter;
          currentMonth = DateTime(pickedDate.year, pickedDate.month);
          _filterActivities();
        });
      }
    } else {
      setState(() {
        selectedFilter = filter;
        _filterActivities();
      });
    }
  }

  void _onMonthChanged(bool isNext) {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        isNext ? currentMonth.month + 1 : currentMonth.month - 1,
      );
      _filterActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FilterButton(
                    label: 'Hari Ini',
                    isSelected: selectedFilter == 'Harian',
                    onTap: () => _onFilterChanged('Harian'),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: FilterButton(
                    label: 'Bulanan',
                    isSelected: selectedFilter == 'Bulanan',
                    onTap: () => _onFilterChanged('Bulanan'),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: FilterButton(
                    label: 'Pilih Tanggal',
                    isSelected: selectedFilter == 'Pilih Tanggal',
                    onTap: () => _onFilterChanged('Pilih Tanggal'),
                  ),
                ),
              ],
            ),
          ),
          if (selectedFilter != 'Harian')
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Colors.lightBlue,
                      size: 30,
                    ),
                    onPressed: () => _onMonthChanged(false),
                  ),
                  SizedBox(width: 16),
                  Text(
                    _getIndonesianMonth(currentMonth),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.lightBlue,
                      size: 30,
                    ),
                    onPressed: () => _onMonthChanged(true),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ActivityCard(activity: activities[index]);
              },
            ),
          ),
        ],
      ),
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
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        side: BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      )
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: activity.isToday ? Colors.blue : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd').format(activity.date),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  activity.day,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clock-in',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  activity.clockIn,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Break Start',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  activity.breakStart,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Break End',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  activity.breakOut,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clock-out',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  activity.clockOut,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: activity.isToday ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}