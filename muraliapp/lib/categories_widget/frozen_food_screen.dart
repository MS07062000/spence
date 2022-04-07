import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/categories_widget/card2.dart';
import 'package:muraliapp/countdowntimer.dart';

class FrozenFoodWidget extends StatefulWidget {
  const FrozenFoodWidget({Key? key}) : super(key: key);

  @override
  State<FrozenFoodWidget> createState() => _FrozenFoodpage();
}

class _FrozenFoodpage extends State<FrozenFoodWidget> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_orders")
      .where('Category', isEqualTo: 'Frozen Food')
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
          'Frozen Foods',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Homepage2Widget()),
            );*/
            Navigator.of(context).pop();
          },
        ),
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
              countdowntimer(FirebaseAuth.instance.currentUser, document.id,
                  data['Expiry Date'], data['Name'], data['Category']);
              return Card2Widget(
                docid: document.id,
                name: data['Name'],
                expirydate: data['Expiry Date'],
                image: data['Product Image'],
                quantity: data['Quantity'],
                manufacturingdate: data['Manufacturing Date'],
                expirydays: data['Expiry Days'],
                location: data['Location'],
                additionalinformation: data['Additional Information'],
                category: data['Category'],
                uniqueid: data['Uniqueid'],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
