import 'package:flutter/material.dart';
import 'package:muraliapp/bottomnavigationbar.dart';
import 'package:muraliapp/countdowntimer.dart';
import 'package:cron/cron.dart';
import 'package:muraliapp/login_signup_widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Homepage2Widget extends StatefulWidget {
  const Homepage2Widget({Key? key}) : super(key: key);

  @override
  State<Homepage2Widget> createState() => _Homepage();
}

class _Homepage extends State<Homepage2Widget> {
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
        Cron().schedule(Schedule.parse('*/5 * * * *'), () async {
          countdowntimer();
        });
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
    return const BottomNavigationBarWidget();
  }
}
