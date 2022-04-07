import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

class garbagereportWidget extends StatefulWidget {
  const garbagereportWidget({Key? key}) : super(key: key);
  @override
  State<garbagereportWidget> createState() => _garbagereport();
}

class _garbagereport extends State<garbagereportWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wastage Report',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  Stream<DocumentSnapshot> provideDocumentFieldStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("user_orders")
        .doc('count2')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          flex: 7,
          child: StreamBuilder<DocumentSnapshot>(
              stream: provideDocumentFieldStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(
                        color: Colors.orange,
                      ));
                }
                var doc = snapshot.data as DocumentSnapshot;
                double num1 = doc.get('Bakery').toDouble();
                double num2 = doc.get('Dairy').toDouble();
                double num3 = doc.get('Medicine').toDouble();
                double num4 = doc.get('Frozen Food').toDouble();
                double num5 = doc.get('Others').toDouble();
                Map<String, double> datamap = {
                  'Bakery': num1,
                  'Dairy': num2,
                  'Medicine': num3,
                  'Frozen Food': num4,
                  'Others': num5,
                };
                return Container(
                    child: Center(
                        child: PieChart(
                  dataMap: datamap,
                  chartRadius: MediaQuery.of(context).size.width / 1.7,
                  legendOptions:
                      LegendOptions(legendPosition: LegendPosition.bottom),
                  chartValuesOptions:
                      ChartValuesOptions(showChartValuesInPercentage: true),
                )));
              })),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => showError(), //deleteUser(),
              child: const Text(
                'Reset',
                style: TextStyle(
                    color: Color.fromRGBO(49, 27, 146, 1), fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
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

  deleteUser() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc("count2")
        .update({
      "Bakery": 0,
      "Dairy": 0,
      "Medicine": 0,
      "Frozen Food": 0,
      "Others": 0
    });
  }
}
