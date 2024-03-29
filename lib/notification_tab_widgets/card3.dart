import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Card3Widget extends StatefulWidget {
  final String name;
  final String expirydate;
  final String docid;
  final int colour;
  const Card3Widget({
    Key? key,
    required this.name,
    required this.expirydate,
    required this.colour,
    required this.docid,
  }) : super(key: key);
  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<Card3Widget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        borderOnForeground: false,
        child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.colour == 1) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('notification')
                          .doc('count')
                          .update({"length": FieldValue.increment(-1)});
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('notification')
                          .doc(widget.docid)
                          .update({"color": 0});
                    }
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: getColor(widget.colour),
                    child: ListTile(
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Your product ',
                          style: TextStyle(color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                            TextSpan(
                              text: ' is going to be expired on ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                                text: widget.expirydate,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                            TextSpan(
                              text: '. Please use it today or remove it.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        color: Colors.orange,
                        onPressed: () {
                          showError();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    )))),
        elevation: 0,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
        //shadowColor: Colors.orange,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ));
    //borderSide: BorderSide(color: Colors.orange, width: 1)));
  }

  Future<void> deleteUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    if (widget.colour == 1) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .doc('count')
          .update({
        "length": FieldValue.increment(-1),
        "length2": FieldValue.increment(-1)
      });
    }

    if (widget.colour == 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notification')
          .doc('count')
          .update({"length2": FieldValue.increment(-1)});
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("notification")
        .doc(widget.docid)
        .delete();
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    deleteUser();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes',
                      style: TextStyle(color: Colors.orange))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('No', style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }
}

Color getColor(int colour) {
  if (colour == 1) {
    return Colors.grey.shade300;
  }
  return Colors.white;
}
