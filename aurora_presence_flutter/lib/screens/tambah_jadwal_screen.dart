import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aurora_presence_flutter/models/schedule.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TambahDataScreen(
        onScheduleAdded: (Schedule newSchedule) {
          // Handle new schedule addition
        },
      ),
    );
  }
}

class TambahDataScreen extends StatefulWidget {
  final Function(Schedule) onScheduleAdded;

  TambahDataScreen({required this.onScheduleAdded});

  @override
  _TambahDataScreenState createState() => _TambahDataScreenState();
}

class _TambahDataScreenState extends State<TambahDataScreen> {
  DateTime? selectedDateStart;
  DateTime? selectedDateEnd;
  TimeOfDay? selectedTimeStart;
  TimeOfDay? selectedTimeEnd;
  List<Person> selectedTeamIndices = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _officeController = TextEditingController(); 
  TextEditingController _searchController = TextEditingController();
  List<TeamMember> teamMembers = [
    TeamMember(name: 'David', image: 'images/david.png'),
    TeamMember(name: 'Lanny', image: 'images/lanny.png'),
    TeamMember(name: 'Andy', image: 'images/andy.png'),
    TeamMember(name: 'Emma', image: 'images/emma.png'),
    TeamMember(name: 'John', image: 'images/john.png'),
    TeamMember(name: 'Shink', image: 'images/shink.png'),
  ];
  List<TeamMember> filteredTeamMembers = [];
  List<Person> selectedMembers = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    filteredTeamMembers = teamMembers;
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          selectedDateStart = picked;
        } else {
          selectedDateEnd = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          selectedTimeStart = picked;
        } else {
          selectedTimeEnd = picked;
        }
      });
    }
  }

  void _filterTeam(String query) {
    final filtered = teamMembers.where((member) {
      return member.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTeamMembers = filtered;
    });
  }

  void _toggleTeamSelection(Person person) {
    setState(() {
      if (selectedMembers.contains(Person(email: person.email, name: person.name, image: person.image))) {
        selectedMembers.remove(Person(email: person.email, name: person.name, image: person.image));
      } else {
        selectedMembers.add(Person(email: person.email, name: person.name, image: person.image));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Tambah Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00CEE8),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  label: 'Schedule Name',
                  hint: 'Schedule Name',
                  controller: _titleController,
                ),
                _buildDateFormField(
                  label: 'Date Start',
                  hint: 'Set Date Start',
                  selectedDate: selectedDateStart,
                  onTap: () => _selectDate(context, true),
                ),
                _buildDateFormField(
                  label: 'Date End',
                  hint: 'Set Date End',
                  selectedDate: selectedDateEnd,
                  onTap: () => _selectDate(context, false),
                ),
                _buildTimeFormField(
                  label: 'Time Start',
                  hint: 'Set Time Start',
                  selectedTime: selectedTimeStart,
                  onTap: () => _selectTime(context, true),
                ),
                _buildTimeFormField(
                  label: 'Time End',
                  hint: 'Set Time End',
                  selectedTime: selectedTimeEnd,
                  onTap: () => _selectTime(context, false),
                ),
                _buildFormField(
                  label: 'Office',
                  hint: 'Enter office name',
                  controller: _officeController,
                ),
                _buildTeamFormField(),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty &&
                          selectedDateStart != null &&
                          selectedDateEnd != null &&
                          selectedTimeStart != null &&
                          selectedTimeEnd != null) {

                        final newSchedule = Schedule(
  title: _titleController.text,
  dateStart: DateFormat('yyyy-MM-dd').format(selectedDateStart!),
  dateEnd: DateFormat('yyyy-MM-dd').format(selectedDateEnd!),
  timeStart: selectedTimeStart!.format(context),
  timeEnd: selectedTimeEnd!.format(context),
  teams: selectedMembers,
  office: _officeController.text,
);

                        widget.onScheduleAdded(newSchedule);
                        Navigator.pop(context);
                      }
                    },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: Color(0xFFA6A6A6), fontWeight: FontWeight.normal),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFormField({
    required String label,
    required String hint,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate)
                        : hint,
                    style: TextStyle(
                        color: selectedDate != null
                            ? Colors.black
                            : Color(0xFFA6A6A6)),
                  ),
                  Icon(Icons.calendar_today, color: Color(0xFF00CEE8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFormField({
    required String label,
    required String hint,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime != null ? selectedTime.format(context) : hint,
                    style: TextStyle(
                        color: selectedTime != null
                            ? Colors.black
                            : Color(0xFFA6A6A6)),
                  ),
                  Icon(Icons.access_time, color: Color(0xFF00CEE8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search and Select Team',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => _filterTeam(value),
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search team...',
                    hintStyle: TextStyle(
                      color: Color(0xFFA6A6A6),
                      fontWeight: FontWeight.normal,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF00CEE8)),
                  ),
                ),
                Divider(color: Colors.grey),
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: filteredTeamMembers.length,
                    itemBuilder: (context, index) {
                      final member = filteredTeamMembers[index];
                      final isSelected = selectedMembers.any((selectedMember) => selectedMember.name == filteredTeamMembers[index].name);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (bool? value) {
                          _toggleTeamSelection(Person(email: "filteredTeamMembers[index].email", name: filteredTeamMembers[index].name, image: filteredTeamMembers[index].image),);
                        },
                        title: Text(member.name),
                        secondary: CircleAvatar(
                          backgroundImage: AssetImage(member.image),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


