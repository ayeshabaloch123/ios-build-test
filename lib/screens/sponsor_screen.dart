import 'package:ayesha_project/components/bottom_bar.dart';
import 'package:ayesha_project/components/sponsor_card.dart';
import 'package:ayesha_project/screens/admin/home_screen.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:ayesha_project/screens/users/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SponsorScreen extends StatefulWidget {
  const SponsorScreen({super.key});

  @override
  State<SponsorScreen> createState() => _SponsorScreenState();
}

class _SponsorScreenState extends State<SponsorScreen> {
  final List<Map<String, dynamic>> sponsors = [
    {
      "name": "Fuller Theological Seminary",
      "level": "PLATINUM",
      "imageUrl": "assests/sponsor_logo.jpeg",
      "socialLinks": ["linkedin", "instagram", "profile"]
    },
    {
      "name": "United Theological Seminary",
      "level": "GOLD",
      "imageUrl": "assests/sponsor_logo.jpeg",
      "socialLinks": ["linkedin", "instagram", "profile"]
    },
    {
      "name": "Tim Lee Creations",
      "level": "BRONZE",
      "imageUrl": "assests/sponsor_logo.jpeg",
      "socialLinks": ["linkedin", "instagram", "profile"]
    },
    {
      "name": "Black History School",
      "level": "BRONZE",
      "imageUrl": "assests/sponsor_logo2.jpeg",
      "socialLinks": ["facebook", "twitter", "website"]
    },
    {
      "name": "Tim Lee And Friends",
      "level": "BRONZE",
      "imageUrl": "assests/sponsor_logo3.jpeg",
      "socialLinks": ["youtube", "linkedin", "profile"]
    },
  ];

  int _selectedIndex = 2;

  // Function to check the user's role from Firestore
  Future<String?> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return doc.data()?['role'] as String?;
        } else {
          print("User document not found");
        }
      } catch (e) {
        print("Error fetching user role: $e");
      }
    }
    return null;
  }

  void _onItemTapped(int index) async {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        final role = await _getUserRole();
        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScheduleScreen()),
        );
        break;
      case 2:
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final role = await _getUserRole();
              if (role == "admin") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminHomeScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
          ),
          centerTitle: true,
          title: const Text(
            'Sponsors',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                _showSettingsDialog();
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sponsors.length,
          itemBuilder: (context, index) {
            final sponsor = sponsors[index];
            return SponsorCard(
              name: sponsor["name"],
              level: sponsor["level"],
              imageUrl: sponsor["imageUrl"],
              socialLinks: sponsor["socialLinks"],
            );
          },
        ),
        bottomNavigationBar: BottomBar(
            selectedIndex: _selectedIndex, onItemTapped: _onItemTapped));
  }
}
