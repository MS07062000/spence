import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/addproductpage.dart';
import 'package:muraliapp/categories_widget/bakery_screen.dart';
import 'package:muraliapp/categories_widget/dairy_screen.dart';
import 'package:muraliapp/categories_widget/frozen_food_screen.dart';
import 'package:muraliapp/categories_widget/medicine_screen.dart';
import 'package:muraliapp/categories_widget/others.dart';
import 'package:muraliapp/expiringsoon.dart';
import 'package:muraliapp/garbagereport.dart';
import 'package:muraliapp/home.dart';
import 'package:muraliapp/home2.dart';

/// This is the stateful widget that the main application instantiates.
// ignore: must_be_immutable
class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigation();
}

/// This is the private State class that goes with Bottom_navigation_bar_widget.
class _BottomNavigation extends State<BottomNavigationBarWidget> {
  /*List<Widget> data = [
    const HomepageWidget(),
    const ExpiringsoonpageWidget(),
    AddproductpageWidget(),
    const HomeTab(),
    const HomeTab(),
  ];*/
  var navigatorKeyList = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];
  var currentIndex = 0;
  var controller = CupertinoTabController(initialIndex: 0);
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: controller,
      tabBar: CupertinoTabBar(
        onTap: (index) {
          if (currentIndex == index) {
            // Navigate to the tab's root route
            navigatorKeyList[index].currentState!.popUntil((route) {
              return route.isFirst;
            });
          }
          currentIndex = index;
        },
        activeColor: Colors.orange,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_rounded),
            label: "Expiring Soon",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.purple),
            label: "Add Product",
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: "Garbage Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: "Notification",
          ),
        ],
        backgroundColor: Colors.white,
      ),
      tabBuilder: (BuildContext _, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              navigatorKey: navigatorKeyList[index],
              routes: {
                '/': (context) => WillPopScope(
                      child: HomepageWidget(),
                      onWillPop: () => Future<bool>.value(true),
                    ),
                'Bakery': (context) => BakeryWidget(),
                'Dairy': (context) => DairyWidget(),
                'Medicine': (context) => MedicineWidget(),
                'Frozen Food': (context) => FrozenFoodWidget(),
                'Others': (context) => OthersWidget(),
              },
            );
          case 1:
            return CupertinoTabView(
              navigatorKey: navigatorKeyList[index],
              routes: {
                '/': (context) => WillPopScope(
                      child: ExpiringsoonpageWidget(),
                      onWillPop: () => Future<bool>.value(true),
                    ),
                'Bakery': (context) => BakeryWidget(),
                'Dairy': (context) => DairyWidget(),
                'Medicine': (context) => MedicineWidget(),
                'Frozen Food': (context) => FrozenFoodWidget(),
                'Others': (context) => OthersWidget(),
              },
            );
          case 2:
            return CupertinoTabView(
              navigatorKey: navigatorKeyList[index],
              routes: {
                '/': (context) => WillPopScope(
                      child:
                          AddproductpageWidget(controller, navigatorKeyList[0]),
                      onWillPop: () => Future<bool>.value(true),
                    ),
                'Bakery': (context) => BakeryWidget(),
                'Dairy': (context) => DairyWidget(),
                'Medicine': (context) => MedicineWidget(),
                'Frozen Food': (context) => FrozenFoodWidget(),
                'Others': (context) => OthersWidget(),
              },
            );
          case 3:
            return CupertinoTabView(
              navigatorKey: navigatorKeyList[index],
              routes: {
                '/': (context) => WillPopScope(
                      child: garbagereportWidget(),
                      onWillPop: () => Future<bool>.value(true),
                    ),
                'Bakery': (context) => BakeryWidget(),
                'Dairy': (context) => DairyWidget(),
                'Medicine': (context) => MedicineWidget(),
                'Frozen Food': (context) => FrozenFoodWidget(),
                'Others': (context) => OthersWidget(),
                'Garbage': (context) => garbagereportWidget(),
              },
            );
          case 4:
            return CupertinoTabView(
              navigatorKey: navigatorKeyList[index],
              routes: {
                '/': (context) => WillPopScope(
                      child: HomeTab(),
                      onWillPop: () => Future<bool>.value(true),
                    ),
                'Bakery': (context) => BakeryWidget(),
                'Dairy': (context) => DairyWidget(),
                'Medicine': (context) => MedicineWidget(),
                'Frozen Food': (context) => FrozenFoodWidget(),
                'Others': (context) => OthersWidget(),
              },
            );
          default:
            return Text('Index must be less than 2');
        }
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
