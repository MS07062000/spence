import 'package:flutter/material.dart';
import 'package:muraliapp/apptitle.dart';
import 'package:muraliapp/bottomnavigationbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _Android1WidgetState();
}

class _Android1WidgetState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      appBar: AppTitleBarWidget(),
      bottomNavigationBar: BottomNavigationBarWidget(),
    ));
  }
}
