import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/bottomnavigationbar.dart';
import 'package:muraliapp/categories_widget/card2.dart';

class BakeryWidget extends StatefulWidget {
  const BakeryWidget({Key? key}) : super(key: key);

  @override
  State<BakeryWidget> createState() => _Bakerypage();
}

class _Bakerypage extends State<BakeryWidget> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('test')
      .where('Category', isEqualTo: 'Bakery')
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
          title: const Text('Bakery'),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWidget()),
              );*/
              Navigator.pop(context);
            },
          )),
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
              return Card2Widget(
                  name: data['Name'],
                  date: data['Expiry Date'],
                  image: data['Expiry Date'],
                  quantity: data['Quantity']);
            }).toList(),
          );
        },
      ),
    );
  }
}
