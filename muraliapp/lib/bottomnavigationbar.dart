import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muraliapp/addproductpage.dart';
import 'package:muraliapp/categories_widget/bakery_screen.dart';
import 'package:muraliapp/categories_widget/condiments.dart';
import 'package:muraliapp/categories_widget/dairy_screen.dart';
import 'package:muraliapp/categories_widget/frozen_food_screen.dart';
import 'package:muraliapp/categories_widget/medicine_screen.dart';
import 'package:muraliapp/categories_widget/others.dart';
import 'package:muraliapp/expiringsoon.dart';
import 'package:muraliapp/garbagereport.dart';
import 'package:muraliapp/home.dart';
import 'package:muraliapp/login_signup_widgets/login.dart';
import 'package:muraliapp/login_signup_widgets/welcome.dart';
import 'package:muraliapp/notification_tab_widgets/notificationpage.dart';
import 'package:muraliapp/notificationapi.dart';

/// This is the stateful widget that the main application instantiates.
// ignore: must_be_immutable
class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigation();
}

/// This is the private State class that goes with Bottom_navigation_bar_widget.
class _BottomNavigation extends State<BottomNavigationBarWidget> {
  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() {
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) {}

  var navigatorKeyList = [
    GlobalKey<NavigatorState>(),
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
          return WillPopScope(
              onWillPop: () async {
                if (currentIndex >= 1) {
                  controller.index = 0;
                  currentIndex = 0;
                  return false;
                } else {
                  SystemNavigator.pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Welcome()));
                  return false;
                }
              },
              child: CupertinoTabScaffold(
                controller: controller,
                tabBar: CupertinoTabBar(
                  inactiveColor: Colors.grey.shade600,
                  backgroundColor: Colors.white,
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
                      icon: Icon(Icons.add_circle_outlined,
                          color: Colors.green.shade600),
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
                ),
                tabBuilder: (BuildContext _, int index) {
                  switch (index) {
                    case 0:
                      return CupertinoTabView(
                        navigatorKey: navigatorKeyList[index],
                        routes: {
                          '/': (context) => WillPopScope(
                                child: HomepageWidget(),
                                onWillPop: () async {
                                  if (controller.index <= 1) {
                                    SystemNavigator.pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Welcome()));
                                    return false;
                                  }
                                  return false;
                                },
                              ),
                          'login': (context) => LoginPage(),
                          'Bakery': (context) => BakeryWidget(),
                          'Dairy': (context) => DairyWidget(),
                          'Medicine': (context) => MedicineWidget(),
                          'Frozen Food': (context) => FrozenFoodWidget(),
                          'Others': (context) => OthersWidget(),
                          'Condiments': (context) => CondimentsWidget(),
                        },
                      );
                    case 1:
                      return CupertinoTabView(
                        navigatorKey: navigatorKeyList[index],
                        routes: {
                          '/': (context) => WillPopScope(
                                child: ExpiringsoonpageWidget(),
                                onWillPop: () async {
                                  if (controller.index >= 1) {
                                    controller.index = 0;
                                    //currentIndex = 0;
                                    return false;
                                  }
                                  return true;
                                },
                              ),
                          'Bakery': (context) => BakeryWidget(),
                          'Dairy': (context) => DairyWidget(),
                          'Medicine': (context) => MedicineWidget(),
                          'Frozen Food': (context) => FrozenFoodWidget(),
                          'Others': (context) => OthersWidget(),
                          'Condiments': (context) => CondimentsWidget(),
                        },
                      );
                    case 2:
                      return CupertinoTabView(
                        navigatorKey: navigatorKeyList[index],
                        routes: {
                          '/': (context) => WillPopScope(
                                child: AddproductpageWidget(
                                    controller, navigatorKeyList[0]),
                                onWillPop: () async {
                                  if (controller.index >= 1) {
                                    controller.index = 0;
                                    //currentIndex = 0;
                                    return false;
                                  }
                                  return true;
                                },
                              ),
                          'Bakery': (context) => BakeryWidget(),
                          'Dairy': (context) => DairyWidget(),
                          'Medicine': (context) => MedicineWidget(),
                          'Frozen Food': (context) => FrozenFoodWidget(),
                          'Others': (context) => OthersWidget(),
                          'home': (context) => HomepageWidget(),
                          'Condiments': (context) => CondimentsWidget(),
                        },
                      );
                    case 3:
                      return CupertinoTabView(
                        navigatorKey: navigatorKeyList[index],
                        routes: {
                          '/': (context) => WillPopScope(
                                child: garbagereportWidget(),
                                onWillPop: () async {
                                  if (controller.index >= 1) {
                                    controller.index = 0;
                                    //currentIndex = 0;
                                    return false;
                                  }
                                  return true;
                                },
                              ),
                          'Bakery': (context) => BakeryWidget(),
                          'Dairy': (context) => DairyWidget(),
                          'Medicine': (context) => MedicineWidget(),
                          'Frozen Food': (context) => FrozenFoodWidget(),
                          'Others': (context) => OthersWidget(),
                          'Garbage': (context) => garbagereportWidget(),
                          'Condiments': (context) => CondimentsWidget(),
                        },
                      );
                    case 4:
                      return CupertinoTabView(
                        navigatorKey: navigatorKeyList[index],
                        routes: {
                          '/': (context) => WillPopScope(
                                child: notificationpageWidget(),
                                onWillPop: () async {
                                  if (controller.index >= 1) {
                                    controller.index = 0;
                                    //currentIndex = 0;
                                    return false;
                                  }
                                  return true;
                                },
                              ),
                          'Bakery': (context) => BakeryWidget(),
                          'Dairy': (context) => DairyWidget(),
                          'Medicine': (context) => MedicineWidget(),
                          'Frozen Food': (context) => FrozenFoodWidget(),
                          'Others': (context) => OthersWidget(),
                          'Condiments': (context) => CondimentsWidget(),
                        },
                      );
                    default:
                      return Text('Index must be less than 2');
                  }
                },
              ));
        }
        return WillPopScope(
            onWillPop: () async {
              if (currentIndex >= 1) {
                controller.index = 0;
                //currentIndex = 0;
                return false;
              } else {
                SystemNavigator.pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Welcome()));
                return true;
              }
            },
            child: CupertinoTabScaffold(
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
                        color: Colors.green.shade900),
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
                              onWillPop: () async {
                                if (controller.index <= 1) {
                                  SystemNavigator.pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Welcome()));
                                  return true;
                                }
                                return false;
                              },
                            ),
                        'login': (context) => LoginPage(),
                        'Bakery': (context) => BakeryWidget(),
                        'Dairy': (context) => DairyWidget(),
                        'Medicine': (context) => MedicineWidget(),
                        'Frozen Food': (context) => FrozenFoodWidget(),
                        'Others': (context) => OthersWidget(),
                        'Condiments': (context) => CondimentsWidget(),
                      },
                    );
                  case 1:
                    return CupertinoTabView(
                      navigatorKey: navigatorKeyList[index],
                      routes: {
                        '/': (context) => WillPopScope(
                              child: ExpiringsoonpageWidget(),
                              onWillPop: () async {
                                if (controller.index >= 1) {
                                  controller.index = 0;
                                  //currentIndex = 0;
                                  return false;
                                }
                                return true;
                              },
                            ),
                        'Bakery': (context) => BakeryWidget(),
                        'Dairy': (context) => DairyWidget(),
                        'Medicine': (context) => MedicineWidget(),
                        'Frozen Food': (context) => FrozenFoodWidget(),
                        'Others': (context) => OthersWidget(),
                        'Condiments': (context) => CondimentsWidget(),
                      },
                    );
                  case 2:
                    return CupertinoTabView(
                      navigatorKey: navigatorKeyList[index],
                      routes: {
                        '/': (context) => WillPopScope(
                              child: AddproductpageWidget(
                                  controller, navigatorKeyList[0]),
                              onWillPop: () async {
                                if (controller.index >= 1) {
                                  controller.index = 0;
                                  //currentIndex = 0;
                                  return false;
                                }
                                return true;
                              },
                            ),
                        'Bakery': (context) => BakeryWidget(),
                        'Dairy': (context) => DairyWidget(),
                        'Medicine': (context) => MedicineWidget(),
                        'Frozen Food': (context) => FrozenFoodWidget(),
                        'Others': (context) => OthersWidget(),
                        'home': (context) => HomepageWidget(),
                        'Condiments': (context) => CondimentsWidget(),
                      },
                    );
                  case 3:
                    return CupertinoTabView(
                      navigatorKey: navigatorKeyList[index],
                      routes: {
                        '/': (context) => WillPopScope(
                              child: garbagereportWidget(),
                              onWillPop: () async {
                                if (controller.index >= 1) {
                                  controller.index = 0;
                                  //currentIndex = 0;
                                  return false;
                                }
                                return true;
                              },
                            ),
                        'Bakery': (context) => BakeryWidget(),
                        'Dairy': (context) => DairyWidget(),
                        'Medicine': (context) => MedicineWidget(),
                        'Frozen Food': (context) => FrozenFoodWidget(),
                        'Others': (context) => OthersWidget(),
                        'Garbage': (context) => garbagereportWidget(),
                        'Condiments': (context) => CondimentsWidget(),
                      },
                    );
                  case 4:
                    return CupertinoTabView(
                      navigatorKey: navigatorKeyList[index],
                      routes: {
                        '/': (context) => WillPopScope(
                              child: notificationpageWidget(),
                              onWillPop: () async {
                                if (controller.index >= 1) {
                                  controller.index = 0;
                                  //currentIndex = 0;
                                  return false;
                                }
                                return true;
                              },
                            ),
                        'Bakery': (context) => BakeryWidget(),
                        'Dairy': (context) => DairyWidget(),
                        'Medicine': (context) => MedicineWidget(),
                        'Frozen Food': (context) => FrozenFoodWidget(),
                        'Others': (context) => OthersWidget(),
                        'Condiments': (context) => CondimentsWidget(),
                      },
                    );
                  default:
                    return Text('Index must be less than 2');
                }
              },
            ));
      },
    );
  }
}
