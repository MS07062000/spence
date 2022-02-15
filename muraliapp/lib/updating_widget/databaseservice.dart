/*import 'package:muraliapp/updating_widget/brew.dart';
import 'package:muraliapp/updating_widget/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection=Firestore.instance.collection('test');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        Name: doc.data['Name'] ?? '',
        Manufacturing_Date: doc.data['Manufacturing Date'] ?? '',
        Expiry_Date: doc.data['Expiry Date'] ?? '',
        Expiry_Days: doc.data['Expiry Days'] ?? '',
        Quantity: doc.data['Expiry Date'] ?? '',
        Product_Image: doc.data['Product Image'] ?? '',
        Category: doc.data['Category'] ?? '',
        Location: doc.data['Location'] ?? '',
        Additional_Information: doc.data['Additional Information'] ?? '',
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      Name: snapshot.data['Name'],
      Manufacturing_Date: snapshot.data['Manufacturing Date'],
      Expiry_Date: snapshot.data['Expiry Date'],
      Expiry_Days: snapshot.data['Expiry Days'],
      Quantity: snapshot..data['Expiry Date'],
      Product_Image: snapshot..data['Product Image'],
      Category: snapshot.data['Category'],
      Location: snapshot.data['Location'],
      Additional_Information: snapshot.data['Additional Information'],
    );
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
*/