import 'package:flutter/material.dart';
import 'package:petproject/faces/infopage.dart';
import 'package:petproject/faces/profile.dart';
import 'package:petproject/faces/today.dart';

class BottomNavWithCards extends StatefulWidget {
  @override
  _BottomNavWithCardsState createState() => _BottomNavWithCardsState();
}

class _BottomNavWithCardsState extends State<BottomNavWithCards> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TodayPage(),
    informationPage(
      initialSearchQuery: '',
    ),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
