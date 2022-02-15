import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/addproductpage.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddproductpageWidget()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CardWidget(
          value: "Bakery",
          image: 'assets/bakery 1.png',
          screen_name: const BakeryWidget(),
          num: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Bakery")
                  .snapshots()
                  .length
                  .toString()
                  .isEmpty
              ? 0.toString()
              : FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Bakery")
                  .snapshots()
                  .length
                  .toString(),
        ),
        CardWidget(
          value: "Dairy",
          image: 'assets/dairy 1.png',
          screen_name: const DairyWidget(),
          num: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Dairy")
                  .snapshots()
                  .length
                  .toString()
                  .isEmpty
              ? 0.toString()
              : FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Dairy")
                  .snapshots()
                  .length
                  .toString(),
        ),
        CardWidget(
          value: "Medicine",
          image: 'assets/pills 1.png',
          screen_name: const MedicineWidget(),
          num: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Medicine")
                  .snapshots()
                  .length
                  .toString()
                  .isEmpty
              ? 0.toString()
              : FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Medicine")
                  .snapshots()
                  .length
                  .toString(),
        ),
        CardWidget(
          value: "Frozen Food",
          image: 'assets/frozen-food 1.png',
          screen_name: const FrozenFoodWidget(),
          num: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Frozen Food")
                  .snapshots()
                  .length
                  .toString()
                  .isEmpty
              ? 0.toString()
              : FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Frozen Food")
                  .snapshots()
                  .length
                  .toString(),
        ),
        CardWidget(
          value: "Others",
          image: 'assets/bakery.png',
          screen_name: const OthersWidget(),
          num: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Others")
                  .snapshots()
                  .length
                  .toString()
                  .isEmpty
              ? 0.toString()
              : FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection("user_orders")
                  .where('Category', isEqualTo: "Others")
                  .snapshots()
                  .length
                  .toString(),
        ),
      ],
    );
  }
}
