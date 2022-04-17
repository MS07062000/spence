import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/categories_widget/card2.dart';
import 'package:muraliapp/countdowntimer.dart';
import 'package:muraliapp/home2.dart';

class BakeryWidget extends StatefulWidget {
  const BakeryWidget({Key? key}) : super(key: key);

  @override
  State<BakeryWidget> createState() => _Bakerypage();
}

class _Bakerypage extends State<BakeryWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int number = 0;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('user_orders')
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bakery',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton(
              onSelected: (int value) {
                setState(() {
                  number = value;
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Sort Alphabetical"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("Sort by Expiry Days"),
                      value: 2,
                    ),
                  ])
        ],
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
          List list1 = [];
          List list2 = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            final docentries = <String, String>{'id': document.id};
            data.addEntries(docentries.entries);
            list1.add(data);
            list2.add(data);
          }).toList();

          list1.sort((a, b) => a['Name'].compareTo(b["Name"]));
          list2.sort((a, b) => a['Expiry Days'].compareTo(b["Expiry Days"]));

          return number == 0
              ? ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    //countdowntimer(FirebaseAuth.instance.currentUser,document.id, data[])
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    countdowntimer(
                        FirebaseAuth.instance.currentUser,
                        document.id,
                        data['Expiry Date'],
                        data['Name'],
                        data['Category']);
                    return Card2Widget(
                      docid: document.id,
                      name: data['Name'],
                      modifiedname: data['ModifiedName'],
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
                )
              : number == 1
                  ? ListView.builder(
                      itemCount: list1.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card2Widget(
                          docid: list1[index]['id'],
                          name: list1[index]['Name'],
                          expirydate: list1[index]['Expiry Date'],
                          image: list1[index]['Product Image'],
                          quantity: list1[index]['Quantity'],
                          manufacturingdate: list1[index]['Manufacturing Date'],
                          expirydays: list1[index]['Expiry Days'],
                          location: list1[index]['Location'],
                          additionalinformation: list1[index]
                              ['Additional Information'],
                          category: list1[index]['Category'],
                          uniqueid: list1[index]['Uniqueid'],
                          modifiedname: list1[index]['ModifiedName'],
                        );
                      },
                    )
                  : number == 2
                      ? ListView.builder(
                          itemCount: list2.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card2Widget(
                              docid: list2[index]['id'],
                              name: list2[index]['Name'],
                              expirydate: list2[index]['Expiry Date'],
                              image: list2[index]['Product Image'],
                              quantity: list2[index]['Quantity'],
                              manufacturingdate: list2[index]
                                  ['Manufacturing Date'],
                              expirydays: list2[index]['Expiry Days'],
                              location: list2[index]['Location'],
                              additionalinformation: list2[index]
                                  ['Additional Information'],
                              category: list2[index]['Category'],
                              uniqueid: list2[index]['Uniqueid'],
                              modifiedname: list2[index]['ModifiedName'],
                            );
                          },
                        )
                      : new Container();
        },
      ),
    );
  }
}
