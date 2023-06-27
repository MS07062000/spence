import 'package:flutter/material.dart';
import 'package:bottomnavigationbar.dart';
import 'package:categories_widget/bakery_screen.dart';
import 'package:categories_widget/dairy_screen.dart';
import 'package:categories_widget/frozen_food_screen.dart';
import 'package:categories_widget/medicine_screen.dart';
import 'package:categories_widget/others.dart';
import 'package:login_signup_widgets/login.dart';
import 'package:login_signup_widgets/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //add here firebaseoptions
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => const LoginPage(),
        "/home": (BuildContext context) => BottomNavigationBarWidget(),
        "/Bakery": (BuildContext context) => const BakeryWidget(),
        "/Dairy": (BuildContext context) => const DairyWidget(),
        "/Medicine": (BuildContext context) => const MedicineWidget(),
        "/Others": (BuildContext context) => const OthersWidget(),
        "/Frozen Food": (BuildContext context) => const FrozenFoodWidget(),
      },
      home: const Welcome(),
    );
  }
}
