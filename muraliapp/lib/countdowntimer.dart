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
                snapshot.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  data.update('Expiry Days',
                      days_calculation(DateTime.now(), data['Expiry Date']));
                }),
              }
          });
}

// ignore: non_constant_identifier_names
days_calculation(DateTime day1, String expirydate1) {
  day1 = DateTime(day1.year, day1.month, day1.day);
  DateTime expirydate2 = DateTime(
      int.parse(expirydate1.substring(6)),
      int.parse(expirydate1.substring(3, 5)),
      int.parse(expirydate1.substring(0, 2)));
  var differenceInDays = expirydate2.difference(day1).inDays;
  return differenceInDays;
}
