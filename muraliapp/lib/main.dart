import 'package:flutter/material.dart';
import 'package:muraliapp/login_signup_widgets/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muraliapp/home2.dart';

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
