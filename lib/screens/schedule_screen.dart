import 'package:ayesha_project/components/bottom_bar.dart';
import 'package:ayesha_project/screens/admin/home_screen.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:ayesha_project/screens/sponsor_screen.dart';
import 'package:ayesha_project/screens/users/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1;
  int _selectedDateIndex = 0;

  final List<List<Map<String, dynamic>>> _schedules = [
    // Schedule for 9th December
    [
      {
        'icon': Icons.breakfast_dining,
        'title': 'Breakfast',
        'speaker': '',
        'time': '9:00 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Worship & Word',
        'speaker': 'Dr. Eric Vickers',
        'time': '9:45 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': "Session 1: Deep Dive into Your Church's Win-Loss Record",
        'speaker': 'Rev. Matthew Watley',
        'time': '10:30 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': 'Platinum Sponsor/Fuller Theological Seminary',
        'speaker': '',
        'time': '11:40 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.timer,
        'title': 'Break',
        'speaker': '',
        'time': '11:50 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Session 2: When the Coach Is Part of the Problem',
        'speaker': 'Ms. Theresa Allen, MSW',
        'time': '12:00 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': 'Gold Sponsor/Logos',
        'speaker': '',
        'time': '1:15 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.lunch_dining,
        'title': 'Lunch',
        'speaker': '',
        'time': '1:25 PM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Session 3: Recruiting, Managing, and Releasing Players',
        'speaker': 'Dr. Lance Watson',
        'time': '2:15 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.timer,
        'title': 'Wrap Up While Enjoying Afternoon Break Sweets',
        'speaker': '',
        'time': '3:30 PM',
        'iconColor': Colors.redAccent
      },
    ],
    // Schedule for 10th December
    [
      {
        'icon': Icons.breakfast_dining,
        'title': 'Breakfast',
        'speaker': '',
        'time': '9:00 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Morning Meditation',
        'speaker': '',
        'time': '9:45 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': 'Session 4: Putting the Right Team Members in the Right Place',
        'speaker': 'Dr. D. Darrell Griffin',
        'time': '10:30 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': 'Gold Sponsor/United Theological Seminary',
        'speaker': '',
        'time': '11:45 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.timer,
        'title': 'Break',
        'speaker': '',
        'time': '11:50 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Session 5: Trick to Compensating Your Players',
        'speaker': 'Rev. Courtney Clayton-Jenkins',
        'time': '12:00 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title': 'Sponsor/Tim Lee Creations',
        'speaker': '',
        'time': '1:15 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.lunch_dining,
        'title': 'Wrap Up During Lunch with PM Break Sweets',
        'speaker': '',
        'time': '1:20 PM',
        'iconColor': Colors.redAccent
      },
    ],
    // Schedule for 11th December
    [
      {
        'icon': Icons.breakfast_dining,
        'title': 'Breakfast',
        'speaker': '',
        'time': '9:00 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Worship & Word',
        'speaker': 'Dr. Shareka Newton',
        'time': '9:45 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.people,
        'title':
            'Session 6: Teaching Teams to Run the Right Plays the Right Way',
        'speaker': 'Ms. Claudette Williams',
        'time': '10:30 AM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.timer,
        'title': 'Break',
        'speaker': '',
        'time': '11:45 AM',
        'iconColor': Colors.redAccent
      },
      {
        'icon': Icons.people,
        'title': 'Session 7: Tools for Championship Teams',
        'speaker': 'Dr. Justin Lester',
        'time': '12:00 PM',
        'iconColor': Colors.blueAccent
      },
      {
        'icon': Icons.timer,
        'title': 'Wrap Up During Lunch with PM Break Sweets',
        'speaker': '',
        'time': '1:15 PM',
        'iconColor': Colors.redAccent
      },
    ],
  ];

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
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SponsorScreen()),
        );
        break;
    }
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIndex = index;
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
          'Schedule',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateCard('09', 'Dec, Mon', 0),
                _buildDateCard('10', 'Dec, Tue', 1),
                _buildDateCard('11', 'Dec, Wed', 2),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _schedules[_selectedDateIndex].length,
              itemBuilder: (context, index) {
                final session = _schedules[_selectedDateIndex][index];
                return _buildSessionCard(
                  session['icon'],
                  session['title'],
                  session['speaker'],
                  session['time'],
                  session['iconColor'],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDateCard(String day, String date, int index) {
    bool isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => _onDateSelected(index),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 78, 90, 254)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: isSelected ? Colors.transparent : Colors.grey),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(IconData icon, String title, String speaker,
      String time, Color iconColor) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: speaker.isNotEmpty ? Text(speaker) : null,
        trailing: Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
