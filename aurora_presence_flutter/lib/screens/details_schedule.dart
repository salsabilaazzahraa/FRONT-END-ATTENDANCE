import 'package:flutter/material.dart';
import 'pengajuan_screen.dart';

class DetailsSchedule extends StatefulWidget {
  final Map<String, dynamic> schedule;
  final Function(Map<String, dynamic>) onScheduleUpdate;

  const DetailsSchedule({
    Key? key,
    required this.schedule,
    required this.onScheduleUpdate,
  }) : super(key: key);

  @override
  _DetailsScheduleState createState() => _DetailsScheduleState();
}

class _DetailsScheduleState extends State<DetailsSchedule> {
  late bool isClockInPressed;
  late bool isClockOutPressed;
  late String clockInTime;
  late String clockOutTime;

  @override
  void initState() {
    super.initState();
    isClockInPressed = widget.schedule['clockInTime'] != null;
    isClockOutPressed = widget.schedule['clockOutTime'] != null;
    clockInTime = widget.schedule['clockInTime'] ?? '';
    clockOutTime = widget.schedule['clockOutTime'] ?? '';
  }

  void showConfirmationDialog(String title, String content, VoidCallback onConfirmed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmed();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Schedule',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (previous code remains the same)

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isClockInPressed
                        ? null
                        : () {
                            showConfirmationDialog(
                              'Clock In',
                              'Are you sure you want to Clock In?',
                              () {
                                setState(() {
                                  isClockInPressed = true;
                                  clockInTime = TimeOfDay.now().format(context);
                                  widget.schedule['clockInTime'] = clockInTime;
                                  widget.onScheduleUpdate(widget.schedule);
                                });
                              },
                            );
                          },
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text('Clock In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isClockInPressed
                          ? Colors.grey
                          : const Color(0xFF527DAA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isClockOutPressed || !isClockInPressed
                        ? null
                        : () {
                            showConfirmationDialog(
                              'Clock Out',
                              'Are you sure you want to Clock Out?',
                              () {
                                setState(() {
                                  isClockOutPressed = true;
                                  clockOutTime = TimeOfDay.now().format(context);
                                  widget.schedule['clockOutTime'] = clockOutTime;
                                  widget.schedule['isHistory'] = true;
                                  widget.onScheduleUpdate(widget.schedule);
                                });
                              },
                            );
                          },
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text('Clock Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isClockOutPressed
                          ? Colors.grey
                          : Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PengajuanScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.assignment, color: Colors.black),
              label: const Text('Absen Izin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6F0FF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.share_location_sharp, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.schedule['location'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calendar_today, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Date', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.schedule, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Schedule', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.schedule['date'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(widget.schedule['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.playlist_add_check_circle_outlined,
                              color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Time', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.timer, color: Colors.grey),
                          SizedBox(width: 4),
                          Text('Tolerance', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.schedule['time'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16)
                              ),
                      const Text('5 Menit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 16)
                              ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
