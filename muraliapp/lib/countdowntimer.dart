import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

void countdowntimer(user, id, date, name, category) {
  final _uid = user.uid;
  /*FirebaseFirestore.instance
      .collection('users')
      .doc(_uid)
      .collection('user_orders')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              if (data.containsKey('Expiry Days')) {
                document.reference.update({
                  'Expiry Days': days_calculation(
                      DateTime.now(), data['Expiry Date'].toString())
                });
              }
            })
          });
*/
  int days = days_calculation(DateTime.now(), date);
  if (days <= 0) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc(id)
        .delete();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc("count")
        .update({category: FieldValue.increment(-1)});

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("user_orders")
        .doc("count2")
        .update({category: FieldValue.increment(1)});

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notification")
        .doc("count")
        .update({
      "length2": FieldValue.increment(1),
      "length": FieldValue.increment(1),
    });
    Map<String, dynamic> data = {
      "Name": name,
      "Expiry Date": date,
      "color": 1,
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("notification")
        .add(data);

    FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child(_uid)
        .child(name + '.jpg')
        .delete();
  } else {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('user_orders')
        .doc(id)
        .update({'Expiry Days': days});
  }
}

days_calculation(DateTime day1, expirydate1) {
  day1 = DateTime(day1.year, day1.month, day1.day);
  DateTime expirydate2 = DateTime(
      int.parse(expirydate1.substring(6)),
      int.parse(expirydate1.substring(3, 5)),
      int.parse(expirydate1.substring(0, 2)));
  var differenceInDays = expirydate2.difference(day1).inDays;
  return differenceInDays;
}
