import 'package:flutter/material.dart';
import 'package:muraliapp/addproductpage.dart';
import 'package:muraliapp/bottomnavigationbar.dart';
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
      children: const [
        CardWidget(
          value: "Bakery",
          image: 'assets/bakery 1.png',
          screen_name: BakeryWidget(),
        ),
        CardWidget(
          value: "Dairy",
          image: 'assets/dairy 1.png',
          screen_name: DairyWidget(),
        ),
        CardWidget(
          value: "Medicine",
          image: 'assets/pills 1.png',
          screen_name: MedicineWidget(),
        ),
        CardWidget(
          value: "Frozen Food",
          image: 'assets/frozen-food 1.png',
          screen_name: FrozenFoodWidget(),
        ),
        CardWidget(
          value: "Others",
          image: 'assets/bakery.png',
          screen_name: OthersWidget(),
        ),
      ],
    );
  }
}
