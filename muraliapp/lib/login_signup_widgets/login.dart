import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:muraliapp/home2.dart';
import 'package:muraliapp/login_signup_widgets/reset.dart';
import 'package:muraliapp/login_signup_widgets/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email, _password;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage2Widget()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAuthentification();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        showError(e.message.toString());
      }
    }
  }

  Future<UserCredential> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user =
            await _auth.signInWithCredential(credential);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage2Widget()),
        );

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else {
      throw StateError('Sign in Aborted');
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
        title: const Text(
          'Login',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 200,
                  child: Image(
                    image: AssetImage("assets/logo2.png"),
                    fit: BoxFit.contain,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            validator: (input) =>
                                input != null && !EmailValidator.validate(input)
                                    ? 'Enter a valid email'
                                    : null,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              suffixIcon: const Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.purple.shade800),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                            ),
                            onSaved: (input) => _email = input!),
                        const SizedBox(height: 20),
                        TextFormField(
                            validator: (input) {
                              if (input!.length < 6) {
                                return 'Provide Minimum 6 Character';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: const Icon(Icons.lock),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.purple.shade800),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                            ),
                            obscureText: true,
                            onSaved: (input) => _password = input!),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 10, 70, 10),
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text('Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(20)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.green;
                                  }
                                  return Colors.orange;
                                },
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                primary: Colors.orange,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetScreen()));
                              },
                              child: const Text('Forget Password ?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        SignInButton(Buttons.Google,
                            text: "Log In with Google",
                            onPressed: googleSignIn),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Don't have an account?"),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                primary: Colors.orange,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage()));
                              },
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
