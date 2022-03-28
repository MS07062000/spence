import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void countdowntimer() {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;
  final _uid = user!.uid;

  FirebaseFirestore.instance
      .collection('users')
      .doc(_uid)
      .collection('user_orders')
      .get()
      .then((snapshot) => {
            if (snapshot.docs.isNotEmpty)
              {
                for (var doc in snapshot.docs)
                  {
                    doc.data().update('Expiry Days', ((value) {
                      days_calculation(
                          DateTime.now(), doc.data()['Expiry Date'].toString());
                    }))
                  }
              }
          });
}

// ignore: non_constant_identifier_names
int days_calculation(DateTime day1, String expirydate1) {
  day1 = DateTime(day1.year, day1.month, day1.day);
  DateTime expirydate2 = DateTime(
      int.parse(expirydate1.substring(6)),
      int.parse(expirydate1.substring(3, 5)),
      int.parse(expirydate1.substring(0, 2)));
  var differenceInDays = expirydate2.difference(day1).inDays;
  return differenceInDays;
}
