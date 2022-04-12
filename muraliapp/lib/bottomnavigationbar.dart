import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:muraliapp/notification_tab_widgets/notificationpage.dart';

/// This is the stateful widget that the main application instantiates.
// ignore: must_be_immutable
class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigation();
}

/// This is the private State class that goes with Bottom_navigation_bar_widget.
class _BottomNavigation extends State<BottomNavigationBarWidget> {
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .doc('count')
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return CupertinoTabScaffold(
            controller: controller,
            tabBar: CupertinoTabBar(
              onTap: (index) {
                if (currentIndex == index && currentIndex != 2) {
                  // Navigate to the tab's root route
                  navigatorKeyList[index].currentState!.popUntil((route) {
                    return route.isFirst;
                  });
                }
                currentIndex = index;
              },
              activeColor: Colors.orange,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.hourglass_top_rounded),
                  label: "Expiring Soon",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline_rounded,
                      color: Colors.purple),
                  label: "Add Product",
                  backgroundColor: Colors.orange,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart_outline),
                  label: "Garbage Report",
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: <Widget>[
                      new Icon(Icons.notifications),
                      data['length'] != 0
                          ? new Positioned(
                              right: 0,
                              child: new Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: new Text(
                                    data['length'].toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
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
                            child: AddproductpageWidget(
                                controller, navigatorKeyList[0]),
                            onWillPop: () => Future<bool>.value(true),
                          ),
                      'Bakery': (context) => BakeryWidget(),
                      'Dairy': (context) => DairyWidget(),
                      'Medicine': (context) => MedicineWidget(),
                      'Frozen Food': (context) => FrozenFoodWidget(),
                      'Others': (context) => OthersWidget(),
                      'home': (context) => HomepageWidget(),
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
                            child: notificationpageWidget(),
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
        return CupertinoTabScaffold(
          controller: controller,
          tabBar: CupertinoTabBar(
            onTap: (index) {
              if (currentIndex == index && currentIndex != 2) {
                // Navigate to the tab's root route
                navigatorKeyList[index].currentState!.popUntil((route) {
                  return route.isFirst;
                });
              }
              currentIndex = index;
            },
            activeColor: Colors.orange,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_top_rounded),
                label: "Expiring Soon",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline_rounded,
                    color: Colors.purple),
                label: "Add Product",
                backgroundColor: Colors.orange,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline),
                label: "Garbage Report",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: <Widget>[
                    new Icon(Icons.notifications),
                  ],
                ),
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
                          child: AddproductpageWidget(
                              controller, navigatorKeyList[0]),
                          onWillPop: () => Future<bool>.value(true),
                        ),
                    'Bakery': (context) => BakeryWidget(),
                    'Dairy': (context) => DairyWidget(),
                    'Medicine': (context) => MedicineWidget(),
                    'Frozen Food': (context) => FrozenFoodWidget(),
                    'Others': (context) => OthersWidget(),
                    'home': (context) => HomepageWidget(),
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
                          child: notificationpageWidget(),
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
      },
    );
  }
}
