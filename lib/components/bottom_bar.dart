import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        buildNavBarItem(Icons.home, 0, selectedIndex),
        buildNavBarItem(Icons.calendar_today, 1, selectedIndex),
        buildNavBarItem(Icons.group, 2, selectedIndex),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 8,
    );
  }
}

BottomNavigationBarItem buildNavBarItem(
    IconData icon, int index, int selectedIndex) {
  return BottomNavigationBarItem(
    icon: selectedIndex == index
        ? Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 78, 90, 254),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          )
        : Icon(icon, color: Colors.grey, size: 28),
    label: '',
  );
}
