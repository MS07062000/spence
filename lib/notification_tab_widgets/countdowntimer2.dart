import 'package:cloud_firestore/cloud_firestore.dart';

void countdowntimer2(user, id, date, color) {
  final _uid = user.uid;
  int days = days_calculation(DateTime.now(), date);
  if (days >= 30) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("notification")
        .doc(id)
        .delete();

    if (color == 1) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('notification')
          .doc('count')
          .update({
        "length": FieldValue.increment(-1),
        "length2": FieldValue.increment(-1)
      });
    }

    if (color == 0) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .collection('notification')
          .doc('count')
          .update({"length2": FieldValue.increment(-1)});
    }
  } else {}
}

days_calculation(DateTime day1, expirydate1) {
  day1 = DateTime(day1.year, day1.month, day1.day);
  DateTime expirydate2 = DateTime(
      int.parse(expirydate1.substring(6)),
      int.parse(expirydate1.substring(3, 5)),
      int.parse(expirydate1.substring(0, 2)));
  var differenceInDays = day1.difference(expirydate2).inDays;
  return differenceInDays;
}
