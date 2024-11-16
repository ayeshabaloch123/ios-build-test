import 'package:ayesha_project/models/session.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionTab extends StatelessWidget {
  final Session session;

  const SessionTab({super.key, required this.session});

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('EEEE, MMM dd').format(parsedDate);
    } catch (e) {
      return 'Date Unavailable';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          session.activity,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        const Text(
          'Date',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatDate(session.date),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        const Text(
          'Course',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          session.course,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScheduleScreen()));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 78, 90, 254),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Visit Schedule'),
          ),
        ),
      ],
    );
  }
}
