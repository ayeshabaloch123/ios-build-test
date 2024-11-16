import 'package:ayesha_project/models/session.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:flutter/material.dart';

class GeneralTab extends StatelessWidget {
  final Session session;

  const GeneralTab({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          session.name,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        const Text(
          'Biography',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          session.description,
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
