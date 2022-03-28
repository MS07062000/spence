import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/expiringsoon.dart';
import 'package:muraliapp/home.dart';

/// This is the stateful widget that the main application instantiates.
class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigation();
}

/// This is the private State class that goes with Bottom_navigation_bar_widget.
class _BottomNavigation extends State<BottomNavigationBarWidget> {
  List<Widget> data = [
    const HomepageWidget(),
    const HomeTab(),
    const HomeTab(),
    const ExpiringsoonpageWidget(),
    const HomeTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.orange,
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
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_rounded),
            label: "Expiring Soon",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "Garbage Report",
          ),
        ],
        backgroundColor: Colors.white,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) {
            return data[index];
          },
        );
      },
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: const Text(
          "This is home page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
