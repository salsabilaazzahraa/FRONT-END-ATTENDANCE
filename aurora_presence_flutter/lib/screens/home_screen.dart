import 'package:aurora_presence_flutter/screens/out.dart';
import 'package:aurora_presence_flutter/screens/presensi_screen.dart';
import 'package:aurora_presence_flutter/screens/succes.dart';
import 'package:aurora_presence_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'pengajuan_screen.dart';
import 'information_screen.dart';
import 'tugas_screen.dart';
import 'schedule_page.dart';
import 'package:aurora_presence_flutter/screens/activity_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'profile_screen.dart';
import 'break_start.dart';
import 'break_out.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  Color _seeAllColorSchedule = Colors.black;
  Color _seeAllColorAnnouncement = Colors.black;
  Color _seeAllColorTask = Colors.black;
  late DateTime now;
  late Timer _timer;
  String? _selectedLocation;
  TextEditingController _locationController = TextEditingController();
  List<String> _locations = [
    'IDS Indonesia Cilandak',
    'IDS Indonesia Cibubur',
    'Lainnya'
  ];
  bool hasClockInToday = false;
  bool isOnTime = false;
  bool _isBreakStartDone = false;
  bool _isBreakOutDone = false;
  bool _isClockInDone = false;
  bool _isClockOutDone = false;
  bool _isBreakStartAvailable = false;
  bool _isBreakOutAvailable = false;
  bool isClockInTime = false;
  bool isBreakStartTime = false;
  bool isBreakOutTime = false;
  bool isClockOutTime = false;

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
    _loadUsername();
    now = DateTime.now();
    _loadSelectedLocation();
    _loadLocations();
    loadAttendanceStatus();
    _checkAndResetClockStatus();
    _checkBreakAvailability();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        now = DateTime.now();
        _updateTimeStatus();
      });
    });
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "Username";
    });
  }

  void _updateTimeStatus() {
    isClockInTime = now.hour >= 8 && now.hour < 17;
    isClockOutTime = now.hour >= 17 || now.hour < 8;
    isBreakStartTime = now.hour >= 12 && now.hour < 13;
    isBreakOutTime = now.hour >= 13 && now.hour < 14;
  }

  @override
  void dispose() {
    _timer.cancel();
    _locationController.dispose();
    super.dispose();
  }

  void _checkBreakAvailability() {
    setState(() {
      now = DateTime.now();
      _isBreakStartAvailable = now.hour == 12;
      _isBreakOutAvailable = now.hour == 13 && now.minute <= 60;
    });
  }

  Future<void> _checkAndResetClockStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastClockDate = prefs.getString('lastClockDate');
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    if (lastClockDate == null || lastClockDate != todayDate) {
      await prefs.setBool('isClockInDone', false);
      await prefs.setBool('isBreakStartDone', false);
      await prefs.setBool('isBreakOutDone', false);
      await prefs.setBool('isClockOutDone', false);
      await prefs.setString('lastClockDate', todayDate);

      setState(() {
        _isClockInDone = false;
        _isBreakStartDone = false;
        _isBreakOutDone = false;
        _isClockOutDone = false;
      });
    } else {
      _loadClockInStatus();
      _loadBreakStartStatus();
      _loadBreakOutStatus();
      _loadClockOutStatus();
    }
  }

  Future<void> _checkAndResetBreakStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastBreakStartDate = prefs.getString('lastBreakStartDate');
    String? lastBreakOutDate = prefs.getString('lastBreakOutDate');
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    if (lastBreakStartDate == null || lastBreakStartDate != todayDate) {
      await prefs.setBool('isBreakStartDone', false);
      setState(() {
        _isBreakStartDone = false;
      });
    } else {
      _loadBreakStartStatus();
    }

    if (lastBreakOutDate == null || lastBreakOutDate != todayDate) {
      await prefs.setBool('isBreakOutDone', false);
      setState(() {
        _isBreakOutDone = false;
      });
    } else {
      _loadBreakOutStatus();
    }
  }

  Future<void> loadAttendanceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasClockInToday = prefs.getBool('isClockInDone') ?? false;
      isOnTime = prefs.getBool('isOnTime') ?? false;
    });
  }

  Future<void> _setClockInStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockInDone', status);
    DateTime now = DateTime.now();
    bool isOnTime = now.hour >= 8 && now.hour < 10;
    await prefs.setBool('isOnTime', isOnTime);
    setState(() {
      _isClockInDone = status;
      hasClockInToday = status;
      this.isOnTime = isOnTime;
    });
    await prefs.setString(
        'lastClockDate', DateFormat('yyyy-MM-dd').format(now));
  }

  Future<void> _setBreakStartStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBreakStartDone', status);
    setState(() {
      _isBreakStartDone = status;
    });
    await prefs.setString(
        'lastBreakStartDate', DateFormat('yyyy-MM-dd').format(now));
  }

  Future<void> _setBreakOutStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBreakOutDone', status);
    setState(() {
      _isBreakOutDone = status;
    });
    await prefs.setString(
        'lastBreakOutDate', DateFormat('yyyy-MM-dd').format(now));
  }

  Future<void> _setClockOutStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isClockOutDone', status);
    setState(() {
      _isClockOutDone = status;
    });
    await prefs.setString(
        'lastClockDate', DateFormat('yyyy-MM-dd').format(now));
  }

  Future<void> _saveSelectedLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLocation', location);
  }

  Future<void> _loadSelectedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLocation = prefs.getString('selectedLocation');
    });
  }

  Future<void> _saveLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('locations', _locations);
  }

  Future<void> _loadLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations') ?? _locations;
    });
  }

  Future<void> _loadClockInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isClockInDone = prefs.getBool('isClockInDone') ?? false;
    });
  }

  Future<void> _loadBreakStartStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBreakStartDone = prefs.getBool('isBreakStartDone') ?? false;
    });
  }

  Future<void> _loadBreakOutStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBreakOutDone = prefs.getBool('isBreakOutDone') ?? false;
    });
  }

  Future<void> _loadClockOutStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isClockOutDone = prefs.getBool('isClockOutDone') ?? false;
    });
  }

  Future<void> _showLocationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Lokasi', textAlign: TextAlign.center),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._locations.map((location) {
                    return GestureDetector(
                      child: Row(
                        children: [
                          Radio(
                            value: location,
                            groupValue: _selectedLocation,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedLocation = value;
                              });
                              if (value == 'Lainnya') {
                                setState(() {
                                  _selectedLocation = value;
                                });
                              } else {
                                _saveSelectedLocation(value!);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          SizedBox(width: 8),
                          Text(location),
                        ],
                      ),
                    );
                  }).toList(),
                  if (_selectedLocation == 'Lainnya')
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan lokasi baru',
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                if (_selectedLocation == 'Lainnya' &&
                    _locationController.text.isNotEmpty) {
                  String newLocation = _locationController.text;
                  if (!_locations.contains(newLocation)) {
                    setState(() {
                      _selectedLocation = newLocation;
                      _locations.insert(_locations.length - 1, newLocation);
                    });
                    _saveSelectedLocation(newLocation).then((_) {
                      _saveLocations();
                    });
                  }
                } else if (_selectedLocation != null) {
                  _saveSelectedLocation(_selectedLocation!).then((_) {
                    setState(() {});
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentTime = DateFormat('hh:mm a').format(now);
    String currentDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    bool isClockInTime = now.hour >= 8 && now.hour < 17;
    bool isClockOutTime = now.hour >= 17 || now.hour < 8;
    bool isBreakStartTime = now.hour >= 12 && now.hour < 13;
    bool isBreakOutTime = now.hour >= 13 && now.hour < 14;
    bool isWithinGracePeriod =
        now.isAfter(DateTime(now.year, now.month, now.day, 8, 0)) &&
            now.isBefore(DateTime(now.year, now.month, now.day, 8, 5));
    bool isLate = now.isAfter(DateTime(now.year, now.month, now.day, 8, 5)) &&
        now.isBefore(DateTime(now.year, now.month, now.day, 17, 0));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Color.fromRGBO(101, 237, 255, 0),
          flexibleSpace: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('images/profil.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            username.isNotEmpty ? username : "Username",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'images/kantor1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/kantor2.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'images/kantor3.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentDate,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          FittedBox(
                            child: GestureDetector(
                              onTap: () {
                                _showLocationDialog();
                              },
                              child: Icon(Icons.location_on),
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              _selectedLocation ??
                                  'Pilih Lokasi Kantor Kamu Hari Ini',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Color.fromARGB(255, 128, 255, 130),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                isClockInTime
                                    ? DateFormat('HH:mm').format(DateTime(
                                        now.year, now.month, now.day, 8, 0))
                                    : isClockOutTime
                                        ? DateFormat('HH:mm').format(DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                            17,
                                            0))
                                        : isBreakStartTime
                                            ? DateFormat('HH:mm').format(
                                                DateTime(now.year, now.month,
                                                    now.day, 12, 0))
                                            : isBreakOutTime
                                                ? DateFormat('HH:mm').format(
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day,
                                                        13,
                                                        0))
                                                : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Text(
                                DateFormat('HH:mm').format(now),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      if (isClockInTime && !_isClockInDone)
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: (now.hour >= 8 && now.hour < 10)
                                ? Colors.blue
                                : Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            (now.hour >= 8 && now.hour < 10)
                                ? 'Selamat Beraktivitas'
                                : 'Anda sudah terlambat!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (_isClockInDone) ...[
                        if (now.hour == 12 &&
                            now.minute >= 0 &&
                            now.minute < 29)
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Selamat makan siang',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (now.hour == 12 &&
                            now.minute >= 29 &&
                            now.minute <= 59)
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Jam makan siang akan segera berakhir',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (now.hour == 13 &&
                            now.minute >= 0 &&
                            now.minute < 29)
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Makan siang sudah selesai',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (now.hour == 13 &&
                            now.minute >= 29 &&
                            now.minute <= 59)
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Jam makan siang sudah berakhir',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                      if (isClockOutTime &&
                          _isClockInDone &&
                          !_isClockOutDone &&
                          now.hour >= 17 &&
                          now.hour <= 20)
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Hati-hati di jalan!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: _selectedLocation != null
                      ? ElevatedButton(
                          onPressed: _selectedLocation != null
                              ? () {
                                  if (isClockInTime && !_isClockInDone) {
                                    _setClockInStatus(true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SuccessScreen(
                                          selectedLocation:
                                              _selectedLocation ?? '',
                                        ),
                                      ),
                                    );
                                  } else if (isBreakStartTime &&
                                      !_isBreakStartDone &&
                                      _isClockInDone) {
                                    _setBreakStartStatus(true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BreakStartScreen(
                                          selectedLocation:
                                              _selectedLocation ?? '',
                                        ),
                                      ),
                                    );
                                  } else if (isBreakOutTime &&
                                      !_isBreakOutDone &&
                                      _isBreakStartDone) {
                                    _setBreakOutStatus(true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BreakOutScreen(
                                          selectedLocation:
                                              _selectedLocation ?? '',
                                        ),
                                      ),
                                    );
                                  } else if (isClockOutTime &&
                                      !_isClockOutDone &&
                                      _isClockInDone) {
                                    _setClockOutStatus(true);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OutScreen(
                                          selectedLocation:
                                              _selectedLocation ?? '',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isClockInTime && !_isClockInDone
                                ? const Color.fromARGB(255, 112, 210, 255)
                                : isBreakStartTime &&
                                        !_isBreakStartDone &&
                                        _isClockInDone
                                    ? Colors.orange
                                    : isBreakOutTime &&
                                            !_isBreakOutDone &&
                                            _isBreakStartDone
                                        ? Colors.purple
                                        : isClockOutTime &&
                                                !_isClockOutDone &&
                                                _isClockInDone
                                            ? Colors.blue[900]
                                            : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            isClockInTime && !_isClockInDone
                                ? 'Clock In'
                                : isBreakStartTime &&
                                        !_isBreakStartDone &&
                                        _isClockInDone
                                    ? 'Break Start'
                                    : isBreakOutTime &&
                                            !_isBreakOutDone &&
                                            _isBreakStartDone
                                        ? 'Break Out'
                                        : isClockOutTime &&
                                                !_isClockOutDone &&
                                                _isClockInDone
                                            ? 'Clock Out'
                                            : 'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHorizontalGridItem('images/kerja.png'),
                    _buildHorizontalGridItem('images/pengajuan.png'),
                    _buildHorizontalGridItem('images/informasi.png'),
                    _buildHorizontalGridItem('images/tugas.png'),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 216, 215, 215)),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedule',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _seeAllColorSchedule = Colors.red;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PresensiScreen(),
                              ),
                            ).then((_) {
                              setState(() {
                                _seeAllColorSchedule = Colors.black;
                              });
                            });
                          },
                          child: MouseRegion(
                            onHover: (event) {
                              setState(() {
                                _seeAllColorSchedule = Colors.lightBlue;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                _seeAllColorSchedule = Colors.black;
                              });
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                color: _seeAllColorSchedule,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.collections_bookmark_outlined,
                            color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('Zoom')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.share_location_rounded,
                            color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('PT Maju Kemenangan')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('Wednesday, 08 August, 2024')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.av_timer, color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('09:00 AM - 11:50 AM')),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 216, 215, 215)),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Announcement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _seeAllColorAnnouncement = Colors.red;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformationScreen(),
                              ),
                            ).then((_) {
                              setState(() {
                                _seeAllColorAnnouncement = Colors.black;
                              });
                            });
                          },
                          child: MouseRegion(
                            onHover: (event) {
                              setState(() {
                                _seeAllColorAnnouncement = Colors.lightBlue;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                _seeAllColorAnnouncement = Colors.black;
                              });
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                color: _seeAllColorAnnouncement,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.collections_bookmark_outlined,
                            color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text('Workshop internal keamanan cyber')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('Monday, 01 October, 2024')),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromARGB(255, 216, 215, 215)),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Task',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _seeAllColorTask = Colors.red;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TugasScreen(),
                              ),
                            ).then((_) {
                              setState(() {
                                _seeAllColorTask = Colors.black;
                              });
                            });
                          },
                          child: MouseRegion(
                            onHover: (event) {
                              setState(() {
                                _seeAllColorTask = Colors.lightBlue;
                              });
                            },
                            onExit: (event) {
                              setState(() {
                                _seeAllColorTask = Colors.black;
                              });
                            },
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                color: _seeAllColorTask,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Flexible(child: Text('Tugas . Sisa 2')),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.collections_bookmark_outlined,
                            color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('Konten Marketing')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.blue[400]),
                        SizedBox(width: 8),
                        Flexible(child: Text('Friday, 12 August, 2024')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildHorizontalGridItem(String imagePath) {
    return GestureDetector(
      onTap: () {
        if (imagePath == 'images/pengajuan.png') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PengajuanScreen()));
        } else if (imagePath == 'images/kerja.png') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SchedulePage()));
        } else if (imagePath == 'images/tugas.png') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TugasScreen()));
        } else if (imagePath == 'images/informasi.png') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InformationScreen()));
        }
      },
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(right: 16),
        child: Center(
          child: Image.asset(imagePath, width: 120, height: 120),
        ),
      ),
    );
  }
}

class _getButtonText {}

class _getButtonColor {}
