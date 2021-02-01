import 'package:flutter/material.dart';
import 'package:laundry/ui/account.dart';
import 'package:laundry/ui/booking.dart';
import 'package:laundry/ui/home.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final List<Widget> _page = [
    Home(),
    Booking(),
    Account(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Pesanan'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
        ],
      ),
    );
  }
}
