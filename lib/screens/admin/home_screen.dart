import 'package:ayesha_project/components/bottom_bar.dart';
import 'package:ayesha_project/models/session.dart';
import 'package:ayesha_project/screens/admin/presentation_profile.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:ayesha_project/screens/sponsor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late List<Session> sessions;
  List<Session> _filteredSessions = [];
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSessions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSessions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSessions = sessions
          .where((session) => session.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SponsorScreen()),
        );
        break;
    }
  }

  Future<void> _showSettingsDialog() async {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 80,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 78, 90, 254),
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assests/logo.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _logout();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 78, 90, 254),
                            foregroundColor: Colors.white),
                        child: const Text('Logout'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 50,
            ),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(255, 78, 90, 254),
                  width: 3,
                ),
              ),
              child: const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assests/logo.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.black,
              onPressed: () {
                _showSettingsDialog();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'Hi, Welcome to Rethink & ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Retool',
                      style: TextStyle(
                        color: Color.fromARGB(255, 78, 90, 254),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Text(
                "Let's get started",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search here',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 78, 90, 254),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _filterSessions,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('sessions')
                    .orderBy('sId', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ${snapshot.error.toString()}"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No sessions available"));
                  } else {
                    sessions = snapshot.data!.docs
                        .map((doc) => Session.fromJson(
                            doc.data() as Map<String, dynamic>))
                        .toList();
                    _filteredSessions = _searchController.text.isEmpty
                        ? sessions
                        : sessions
                            .where((session) => session.name
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                            .toList();

                    return ListView.builder(
                      itemCount: _filteredSessions.length,
                      itemBuilder: (context, index) {
                        final session = _filteredSessions[index];
                        return AdminSessionCard(session: session);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class AdminSessionCard extends StatefulWidget {
  final Session session;

  const AdminSessionCard({super.key, required this.session});

  @override
  _AdminSessionCardState createState() => _AdminSessionCardState();
}

class _AdminSessionCardState extends State<AdminSessionCard> {
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
                      builder: (context) => AdminPresenterProfileScreen(
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
