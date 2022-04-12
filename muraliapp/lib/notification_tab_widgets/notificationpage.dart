import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/home2.dart';
import 'package:muraliapp/notification_tab_widgets/card3.dart';
import 'package:muraliapp/notification_tab_widgets/countdowntimer2.dart';

class notificationpageWidget extends StatefulWidget {
  const notificationpageWidget({Key? key}) : super(key: key);

  @override
  State<notificationpageWidget> createState() => _notificationpage();
}

class _notificationpage extends State<notificationpageWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var length2 = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notification')
      .doc('count')
      .snapshots()
      .listen((docSnapshot) {
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      return data['length2'];
    }
  });

  /*FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notification').doc('count').update({"length":0});*/
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notification')
      .orderBy('Expiry Date', descending: true)
      .snapshots();

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homepage2Widget()),
                    );
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  showError2() {
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

  Future<void> deleteUser() async {
    final batch = FirebaseFirestore.instance.batch();
    CollectionReference usersStream_2 = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notification');

    return usersStream_2.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        if (document != 'count') {
          batch.delete(document.reference);
        }
      });

      return batch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notification',
            style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
          ),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
                tooltip: 'Delete All',
                icon: const Icon(Icons.delete_forever_sharp),
                onPressed: () {
                  if (length2 == 0) {
                  } else {
                    showError2();
                  }
                }),
          ],
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  "Note:This notification is going to last only for 30 days.")),
          Expanded(
            flex: 9,
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    countdowntimer2(FirebaseAuth.instance.currentUser,
                        document.id, data['Expiry Date']);
                    return Card3Widget(
                      docid: document.id,
                      name: data['Name'],
                      expirydate: data['Expiry Date'],
                      colour: data['color'],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ]));
  }
}
