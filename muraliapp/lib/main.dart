import 'package:flutter/material.dart';
import 'package:muraliapp/categories_widget/bakery_screen.dart';
import 'package:muraliapp/categories_widget/dairy_screen.dart';
import 'package:muraliapp/categories_widget/frozen_food_screen.dart';
import 'package:muraliapp/categories_widget/medicine_screen.dart';
import 'package:muraliapp/categories_widget/others.dart';
import 'package:muraliapp/login_signup_widgets/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muraliapp/home2.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCwGW_iu-B2JYtq9EhZuUX3idQRWdm5fug",
      appId: "1:801106562107:android:c34c9e0ba79cb25977201e",
      messagingSenderId: "801106562107",
      projectId: "spence-38472",
    ),
  );

  AwesomeNotifications().initialize(
    'resource://drawable/app_icon',
    [
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Scheduled Description',
        defaultColor: Colors.orange,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => const Homepage2Widget(),
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
