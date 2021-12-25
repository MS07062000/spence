import 'package:flutter/material.dart';
import 'package:muraliapp/addproductpage.dart';
import 'package:muraliapp/home.dart';

/// This is the stateful widget that the main application instantiates.
class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigation();
}

/// This is the private State class that goes with Bottom_navigation_bar_widget.
class _BottomNavigation extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    HomepageWidget(),
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Shopping List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_sharp),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "Home",
          ),
        ],
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
