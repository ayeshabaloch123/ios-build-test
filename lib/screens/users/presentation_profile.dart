import 'package:ayesha_project/components/bottom_bar.dart';
import 'package:ayesha_project/models/session.dart';
import 'package:ayesha_project/screens/auth/login_screen.dart';
import 'package:ayesha_project/screens/schedule_screen.dart';
import 'package:ayesha_project/screens/sponsor_screen.dart';
import 'package:ayesha_project/screens/users/assets_tab.dart';
import 'package:ayesha_project/screens/users/home_screen.dart';
import 'package:ayesha_project/screens/users/session_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'general_tab.dart';
import 'notes_tab.dart';
import '../comments_tab.dart';

class PresenterProfileScreen extends StatefulWidget {
  final Session session;

  const PresenterProfileScreen({super.key, required this.session});

  @override
  State<PresenterProfileScreen> createState() => _PresenterProfileScreenState();
}

class _PresenterProfileScreenState extends State<PresenterProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  String googleDriveLinkToDirect(String driveUrl) {
    final fileId = driveUrl.split('/d/')[1].split('/')[0];
    return 'https://drive.google.com/uc?export=view&id=$fileId';
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
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
          MaterialPageRoute(builder: (context) => SponsorScreen()),
        );
        break;
    }
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) {
      print('No URL provided');
      return;
    }

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch URL: $url');
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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Presenter Profile',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  _showSettingsDialog();
                },
                color: Colors.black,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    googleDriveLinkToDirect(widget.session.imageUrl),
                  ),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.session.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Social Media Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => _launchUrl(widget.session.linkedinUrl),
                      child: Image.asset(
                        'assests/icon1.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => _launchUrl(widget.session.instagramUrl),
                      child: Image.asset(
                        'assests/icon2.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () => _launchUrl(widget.session.twitterUrl),
                      child: Image.asset(
                        'assests/icon3.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(text: 'General'),
                      Tab(text: 'Session'),
                      Tab(text: 'Notes'),
                      Tab(text: 'Comments'),
                      Tab(text: 'Assets'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      GeneralTab(session: widget.session),
                      SessionTab(session: widget.session),
                      NotesTab(sessionId: widget.session.id),
                      CommentsTab(sessionId: widget.session.id),
                      AssetsTab(sessionId: widget.session.id)
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          )),
    );
  }
}
