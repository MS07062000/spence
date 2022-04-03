import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class garbagereportWidget extends StatefulWidget {
  const garbagereportWidget({Key? key}) : super(key: key);

  @override
  State<garbagereportWidget> createState() => _garbagereport();
}

class _garbagereport extends State<garbagereportWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wastage Report',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
