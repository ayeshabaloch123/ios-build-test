import 'package:ayesha_project/components/bottom_bar.dart';
import 'package:ayesha_project/models/session.dart';
import 'package:ayesha_project/components/session_card.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:ayesha_project/screens/sponsor_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Session> sessions;
  List<Session> _filteredSessions = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSessionsFromFirestore();
    _searchController.addListener(_filterSessions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
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

  Future<void> _fetchSessionsFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .orderBy('sId', descending: false)
          .get();

      final sessionsData = snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        sessions = sessionsData
            .map((data) => Session.fromJson(data as Map<String, dynamic>))
            .toList();
        _filteredSessions = List.from(sessions);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching sessions: $e");
    }
  }

  void _filterSessions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSessions = sessions
          .where((session) => session.name.toLowerCase().contains(query))
          .toList();
    });
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
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
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredSessions.length,
                    itemBuilder: (context, index) {
                      final session = _filteredSessions[index];
                      return SessionCard(session: session);
                    },
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
