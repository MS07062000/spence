import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/bottomnavigationbar.dart';
import 'package:muraliapp/categories_widget/card2.dart';

class DairyWidget extends StatefulWidget {
  const DairyWidget({Key? key}) : super(key: key);

  @override
  State<DairyWidget> createState() => _Dairypage();
}

class _Dairypage extends State<DairyWidget> {
  Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_orders")
      .where('Category', isEqualTo: 'Dairy')
      .snapshots();
  var myMenuItems = <String>[
    'Expiring within a week',
    'Expiring within a month',
    'Sort Alphabetically',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Expiring within a week':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Dairy')
            .where('Expiry Days', isLessThanOrEqualTo: 7)
            .orderBy('Name')
            .snapshots();
        break;
      case 'Expiring within a month':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Dairy')
            .where('Expiry Days', isGreaterThanOrEqualTo: 7)
            .where('Expiry Days', isLessThanOrEqualTo: 31)
            .orderBy('Name')
            .snapshots();
        break;
      case 'Sort Alphabetically':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Dairy')
            .orderBy('Name')
            .snapshots();
        break;
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dairy'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: onSelect,
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              })
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return showError('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(
                  color: Colors.orange,
                ));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card2Widget(
                  name: data['Name'],
                  date: data['Expiry Days'],
                  image: data['Product Image'],
                  quantity: data['Quantity']);
            }).toList(),
          );
        },
      ),
      // bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
