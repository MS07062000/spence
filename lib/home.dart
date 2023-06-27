import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_widget.dart';
import 'package:categories_widget/bakery_screen.dart';
import 'package:categories_widget/condiments.dart';
import 'package:categories_widget/dairy_screen.dart';
import 'package:categories_widget/frozen_food_screen.dart';
import 'package:categories_widget/medicine_screen.dart';
import 'package:categories_widget/others.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:countdowntimer.dart';
import 'package:login_signup_widgets/login.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({Key? key}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _Homepage();
}

class _Homepage extends State<HomepageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signOut() async {
    _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Spence',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Are you sure you want to Logout?'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  await signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                      (Route<dynamic> route) => false);
                                },
                                child: const Text('Yes',
                                    style: TextStyle(color: Colors.black))),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No',
                                    style: TextStyle(color: Colors.orange)))
                          ],
                        );
                      });
                },
                child: const Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  CollectionReference users = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_orders");

  Future<void> batchupdate() {
    return users.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        countdowntimer(FirebaseAuth.instance.currentUser, document.id,
            data['Expiry Date'], data['Name'], data['Category'], 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("user_orders")
        .doc("count")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
      } else {
        Map<String, dynamic> data = {
          "Bakery": 0,
          "Dairy": 0,
          "Medicine": 0,
          "Frozen Food": 0,
          "Others": 0,
          "Condiments": 0
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .doc("count")
            .set(data);
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notification")
        .doc("count")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
      } else {
        Map<String, dynamic> data = {
          "length": 0,
          "length2": 0,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("notification")
            .doc("count")
            .set(data);
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("user_orders")
        .doc("count2")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
      } else {
        Map<String, dynamic> data = {
          "Bakery": 0,
          "Dairy": 0,
          "Medicine": 0,
          "Frozen Food": 0,
          "Others": 0,
          "Condiments": 0
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .doc("count2")
            .set(data);
      }
    });

    List<String> _value = [
      'Bakery',
      'Dairy',
      'Medicine',
      'Frozen Food',
      'Others',
      "Condiments"
    ];
    List<String> _screenpic = [
      'assets/bakery 1.png',
      'assets/dairy 1.png',
      'assets/pills 1.png',
      'assets/frozen-food 1.png',
      'assets/bakery.png',
      'assets/condiments.png'
    ];
    List<Widget> _screenname = [
      const BakeryWidget(),
      const DairyWidget(),
      const MedicineWidget(),
      const FrozenFoodWidget(),
      const OthersWidget(),
      const CondimentsWidget(),
    ];

    Stream<DocumentSnapshot> provideDocumentFieldStream() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("user_orders")
          .doc('count')
          .snapshots();
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: provideDocumentFieldStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(
                  color: Colors.orange,
                ));
          }
          var doc = snapshot.data as DocumentSnapshot;
          batchupdate();
          return ListView(children: [
            CardWidget(
              value: _value[0],
              image: _screenpic[0],
              screen_name: _screenname[0],
              num: doc.get("Bakery"),
            ),
            CardWidget(
              value: _value[1],
              image: _screenpic[1],
              screen_name: _screenname[1],
              num: doc.get('Dairy'),
            ),
            CardWidget(
              value: _value[2],
              image: _screenpic[2],
              screen_name: _screenname[2],
              num: doc.get('Medicine'),
            ),
            CardWidget(
              value: _value[3],
              image: _screenpic[3],
              screen_name: _screenname[3],
              num: doc.get('Frozen Food'),
            ),
            CardWidget(
              value: _value[5],
              image: _screenpic[5],
              screen_name: _screenname[5],
              num: doc.get('Condiments'),
            ),
            CardWidget(
              value: _value[4],
              image: _screenpic[4],
              screen_name: _screenname[4],
              num: doc.get('Others'),
            ),
          ]);
        });
  }
}
