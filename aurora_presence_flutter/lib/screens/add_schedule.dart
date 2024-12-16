import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aurora_presence_flutter/models/add.dart';

class AddScheduleScreen extends StatefulWidget {
  final Function(AddSchedule) onScheduleAdded;

  AddScheduleScreen({required this.onScheduleAdded});

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  DateTime? selectedDateStart;
  DateTime? selectedDateEnd;
  TimeOfDay? selectedTimeStart;
  TimeOfDay? selectedTimeEnd;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _officeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _officeController.dispose();
    super.dispose();
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
          'Add Schedule',
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
                  icon: Icons.event_note,
                ),
                _buildDateFormField(
                  label: 'Date Start',
                  hint: 'Set Date Start',
                  selectedDate: selectedDateStart,
                  onTap: () => _selectDate(context, true),
                  icon: Icons.calendar_today,
                ),
                _buildDateFormField(
                  label: 'Date End',
                  hint: 'Set Date End',
                  selectedDate: selectedDateEnd,
                  onTap: () => _selectDate(context, false),
                  icon: Icons.calendar_today,
                ),
                _buildTimeFormField(
                  label: 'Time Start',
                  hint: 'Set Time Start',
                  selectedTime: selectedTimeStart,
                  onTap: () => _selectTime(context, true),
                  icon: Icons.access_time,
                ),
                _buildTimeFormField(
                  label: 'Time End',
                  hint: 'Set Time End',
                  selectedTime: selectedTimeEnd,
                  onTap: () => _selectTime(context, false),
                  icon: Icons.access_time,
                ),
                _buildFormField(
                  label: 'Office',
                  hint: 'Enter office name',
                  controller: _officeController,
                  icon: Icons.location_on,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty &&
                          selectedDateStart != null &&
                          selectedDateEnd != null &&
                          selectedTimeStart != null &&
                          selectedTimeEnd != null) {
                        final newSchedule = AddSchedule(
                          title: _titleController.text,
                          dateStart: DateFormat('EEEE, dd MMMM yyyy')
                              .format(selectedDateStart!),
                          dateEnd: DateFormat('EEEE, dd MMMM yyyy')
                              .format(selectedDateEnd!),
                          timeStart: selectedTimeStart!.format(context),
                          timeEnd: selectedTimeEnd!.format(context),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'Add',
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
    required IconData icon,
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
                color: Color(0xFFA6A6A6),
                fontWeight: FontWeight.normal,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              suffixIcon: Icon(icon, color: Colors.grey),
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
    required IconData icon,
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
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                        ? DateFormat('EEEE, dd MMMM yyyy').format(selectedDate)
                        : hint,
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(icon, color: Colors.grey),
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
    required IconData icon,
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
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime != null
                        ? selectedTime.format(context)
                        : hint,
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(icon, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
