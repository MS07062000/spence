import 'package:flutter/material.dart';
import 'package:muraliapp/login_signup_widgets/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      color: Colors.blue,
      home: Welcome(),
    );
  }
}
