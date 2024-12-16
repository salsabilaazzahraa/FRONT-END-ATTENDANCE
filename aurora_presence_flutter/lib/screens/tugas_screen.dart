import 'package:aurora_presence_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_tugas_screen.dart';

class TugasScreen extends StatefulWidget {
  @override
  _TugasScreenState createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, String>> _tugasList = [];
  List<Map<String, String>> _selesaiList = [];
  List<Map<String, String>> _filteredTugasList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTugasList();
  }

  Future<void> _saveTugasList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedTugasList = json.encode(_tugasList);
    String encodedSelesaiList = json.encode(_selesaiList);
    prefs.setString('tugasList', encodedTugasList);
    prefs.setString('selesaiList', encodedSelesaiList);
  }

  Future<void> _loadTugasList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedTugasList = prefs.getString('tugasList');
    String? encodedSelesaiList = prefs.getString('selesaiList');

    if (encodedTugasList != null) {
      setState(() {
        _tugasList = List<Map<String, String>>.from(
          (json.decode(encodedTugasList) as List).map(
            (item) => Map<String, String>.from(item),
          ),
        );
        _filteredTugasList = _tugasList;
      });
    } else {
      _filteredTugasList = _tugasList;
    }

    if (encodedSelesaiList != null) {
      setState(() {
        _selesaiList = List<Map<String, String>>.from(
          (json.decode(encodedSelesaiList) as List).map(
            (item) => Map<String, String>.from(item),
          ),
        );
      });
    }
  }

  void _navigateToAddTugas() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTugasScreen()),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _tugasList.add(result);
        _filteredTugasList = _tugasList;
      });
      _saveTugasList();
    }
  }

  void _markAsDone(int index) {
    setState(() {
      _selesaiList.add(_tugasList[index]);
      _tugasList.removeAt(index);
      _filteredTugasList = _tugasList;
      _tabController.animateTo(1);
    });
    _saveTugasList();
  }

  void _filterTugas(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTugasList = _tugasList;
      } else {
        _filteredTugasList = _tugasList.where((tugas) {
          return tugas["title"]!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          "Tugas",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF00CEE8),
          tabs: [
            Tab(text: "Daftar Tugas"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildDaftarTugas(),
          buildSelesaiTugas(),
        ],
      ),
    );
  }

  Widget buildDaftarTugas() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: _filterTugas,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Cari Tugas",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tugas · Sisa ${_filteredTugasList.length}"),
              IconButton(
                icon: Icon(Icons.add_box_outlined, color: Color(0xFF00CEE8)),
                onPressed: _navigateToAddTugas,
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTugasList.length,
              itemBuilder: (context, index) {
                return buildTugasItem(
                  _filteredTugasList[index]["title"]!,
                  _filteredTugasList[index]["date"]!,
                  Icons.task_alt_outlined,
                  Colors.green,
                  () => _markAsDone(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelesaiTugas() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _selesaiList.isEmpty
          ? Center(child: Text("Belum ada tugas yang selesai."))
          : ListView.builder(
              itemCount: _selesaiList.length,
              itemBuilder: (context, index) {
                return buildTugasItem(
                  _selesaiList[index]["title"]!,
                  _selesaiList[index]["date"]!,
                  null,
                  null,
                  null,
                  isSelesai: true,
                );
              },
            ),
    );
  }

  Widget buildTugasItem(String title, String date, IconData? icon,
      Color? iconColor, VoidCallback? onTap,
      {bool isSelesai = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.assessment_outlined, size: 40, color: Color(0xFF00CEE8)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(date),
              ],
            ),
            Spacer(),
            if (isSelesai)
              Text(
                "Success",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: 30),
          ],
        ),
      ),
    );
  }
}
