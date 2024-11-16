import 'package:ayesha_project/screens/users/presentation_profile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/session.dart';

class SessionCard extends StatefulWidget {
  final Session session;

  const SessionCard({super.key, required this.session});

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  bool isExpanded = false;

  String googleDriveLinkToDirect(String driveUrl) {
    if (driveUrl.contains('/d/')) {
      final fileId = driveUrl.split('/d/')[1].split('/')[0];
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return driveUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      googleDriveLinkToDirect(widget.session.imageUrl)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.session.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: isExpanded
                                  ? widget.session.description
                                  : widget.session.description.length > 50
                                      ? widget.session.description
                                              .substring(0, 50) +
                                          '...'
                                      : widget.session.description,
                            ),
                            if (widget.session.description.length > 50)
                              TextSpan(
                                text: isExpanded ? ' Show less' : ' See more',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      isExpanded = !isExpanded;
                                    });
                                  },
                              ),
                          ],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 78, 90, 254),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PresenterProfileScreen(
                        session: widget.session,
                      ),
                    ),
                  );
                },
                child: const Text('Visit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
