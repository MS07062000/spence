import 'package:flutter/material.dart';
import 'package:muraliapp/login_signup_widgets/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muraliapp/home2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDFZaG9Q8Ywd1sh4WXFf2UBF0Vv43CgCdQ",
      appId: "1:273891007393:android:edbf9f0fbe35a3ab4749e0",
      messagingSenderId: "273891007393",
      projectId: "spence-55e56",
    ),
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
      },
      home: const Welcome(),
    );
  }
}
