import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/updateproductpage.dart';
import 'package:muraliapp/notifications.dart';

class Card2Widget extends StatefulWidget {
  final String docid;
  final String name;
  final String expirydate;
  final String quantity;
  final String image;
  final String manufacturingdate;
  final int expirydays;
  final String location;
  final String additionalinformation;
  final String category;
  final int uniqueid;

  const Card2Widget({
    Key? key,
    required this.docid,
    required this.image,
    required this.name,
    required this.expirydate,
    required this.quantity,
    required this.manufacturingdate,
    required this.expirydays,
    required this.location,
    required this.additionalinformation,
    required this.category,
    required this.uniqueid,
  }) : super(key: key);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<Card2Widget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.network(widget.image, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Expires on " + widget.expirydate,
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      widget.quantity,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateproductpageWidget(
                                  name: widget.name,
                                  manufacturingdate: widget.manufacturingdate,
                                  expirydays: widget.expirydays,
                                  expirydate: widget.expirydate,
                                  quantity: widget.quantity,
                                  location: widget.location,
                                  additionalinformation:
                                      widget.additionalinformation,
                                  category: widget.category,
                                  productimage: widget.image,
                                  docid: widget.docid,
                                  uniqueid: widget.uniqueid,
                                )));
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  color: Colors.orange,
                  onPressed: () {
                    showError();
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            ),
          ],
        ),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.orange,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 1)),
    );
  }

  Future<void> deleteUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc(widget.docid)
        .delete();

    cancelScheduledNotifications(widget.uniqueid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc("count")
        .update({widget.category: FieldValue.increment(-1)});
    return FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child(_uid)
        .child(widget.name + '.jpg')
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
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }
}
