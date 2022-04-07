import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/card_widget.dart';
import 'package:muraliapp/categories_widget/bakery_screen.dart';
import 'package:muraliapp/categories_widget/dairy_screen.dart';
import 'package:muraliapp/categories_widget/frozen_food_screen.dart';
import 'package:muraliapp/categories_widget/medicine_screen.dart';
import 'package:muraliapp/categories_widget/others.dart';
import 'package:muraliapp/login_signup_widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({Key? key}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _Homepage();
}

class _Homepage extends State<HomepageWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser!.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser!;
        isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentification();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spence'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  await signOut();
                },
                child: const Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

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
      'Others'
    ];
    List<String> _screenpic = [
      'assets/bakery 1.png',
      'assets/dairy 1.png',
      'assets/pills 1.png',
      'assets/frozen-food 1.png',
      'assets/bakery.png'
    ];
    List<Widget> _screenname = [
      const BakeryWidget(),
      const DairyWidget(),
      const MedicineWidget(),
      const FrozenFoodWidget(),
      const OthersWidget()
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
              value: _value[4],
              image: _screenpic[4],
              screen_name: _screenname[4],
              num: doc.get('Others'),
            ),
          ]);
        });
  }
}
