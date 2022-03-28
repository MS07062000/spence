import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/categories_widget/card2.dart';
import 'package:muraliapp/categories_widget/branch.dart';
import 'package:muraliapp/home2.dart';

class MedicineWidget extends StatefulWidget {
  const MedicineWidget({Key? key}) : super(key: key);

  @override
  State<MedicineWidget> createState() => _Medicinepage();
}

final _usersStream = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection("user_orders")
    .withConverter<Branch>(
      fromFirestore: (snapshots, _) => Branch.fromJson(snapshots.data()!),
      toFirestore: (branch, _) => branch.toJson(),
    );

enum MedicineQuery { name, month, week }

extension on Query<Branch> {
  /// Create a firebase query from a MedicineQuery
  Query<Branch> query(MedicineQuery query) {
    switch (query) {
      case MedicineQuery.name:
        return where('Category', isEqualTo: 'Medicine').orderBy('Name');
      case MedicineQuery.month:
        return where('Category', isEqualTo: 'Medicine')
            .where('Expiry Days', isGreaterThanOrEqualTo: 7)
            .where('Expiry Days', isLessThanOrEqualTo: 31);

      case MedicineQuery.week:
        return where('Category', isEqualTo: 'Medicine')
            .where('Expiry Days', isGreaterThanOrEqualTo: 1)
            .where('Expiry Days', isLessThanOrEqualTo: 7);
      //.orderBy('Name');
    }
  }
}

class _Medicinepage extends State<MedicineWidget> {
  MedicineQuery query = MedicineQuery.name;
  /*final _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_orders")
      .where('Category', isEqualTo: 'Medicine')
      .where('Expiry Days', isGreaterThanOrEqualTo: 1)
      .snapshots();
  var myMenuItems = <String>[
    'Expiring within a week',
    'Expiring within a month',
    'Sort Alphabetically',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Expiring within a week':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Medicine')
            .where('Expiry Days', isGreaterThanOrEqualTo: 1)
            .where('Expiry Days', isLessThanOrEqualTo: 7)
            .orderBy('Name')
            .snapshots();
        build(context);
        break;
      case 'Expiring within a month':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Medicine')
            .where('Expiry Days', isGreaterThanOrEqualTo: 7)
            .where('Expiry Days', isLessThanOrEqualTo: 31)
            .orderBy('Name')
            .snapshots();
        build(context);
        break;
      case 'Sort Alphabetically':
        _usersStream = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("user_orders")
            .where('Category', isEqualTo: 'Medicine')
            .orderBy('Name')
            .snapshots();
        build(context);
        break;
    }
  }*/

  showError(String errormessage) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine',
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
        actions: <Widget>[
          PopupMenuButton<MedicineQuery>(
            onSelected: (value) => setState(() => query = value),
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: MedicineQuery.week,
                  child: Text('Expiring within a week'),
                ),
                const PopupMenuItem(
                  value: MedicineQuery.month,
                  child: Text('Expiring within a month'),
                ),
                const PopupMenuItem(
                  value: MedicineQuery.name,
                  child: Text('Sort Alphabetically'),
                ),
              ];
            },
          ),
        ],
        /*actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: onSelect,
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              })
        ],*/
      ),
      body: StreamBuilder<QuerySnapshot<Branch>>(
        stream: _usersStream.query(query).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(
                  color: Colors.orange,
                ));
          }

          final data = snapshot.requireData;
          return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                /*children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;*/
                return Card2Widget(
                  docid: data.docs[index].data().docid,
                  name: data.docs[index].data().name, //data['Name'],
                  expirydate:
                      data.docs[index].data().expirydate, //data['Expiry Days'],
                  image: data.docs[index]
                      .data()
                      .productimage, //data['Product Image'],
                  quantity: data.docs[index].data().quantity,
                  manufacturingdate: data.docs[index].data().manufacturingdate,
                  expirydays: data.docs[index].data().expirydays,
                  location: data.docs[index].data().location,
                  additionalinformation:
                      data.docs[index].data().additionalinformation,
                  category: data.docs[index].data().category,
                  uniqueid: data.docs[index].data().uniqueid,
                ); //data['Quantity']);
              }); //.toList(),
          //);
        },
      ), //bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
