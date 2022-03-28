import 'package:flutter/cupertino.dart';

@immutable
class Branch {
  const Branch({
    required this.docid,
    required this.name,
    required this.manufacturingdate,
    required this.expirydate,
    required this.expirydays,
    required this.quantity,
    required this.productimage,
    required this.category,
    required this.location,
    required this.additionalinformation,
    required this.uniqueid,
  });

  Branch.fromJson(Map<String, Object?> json)
      : this(
            docid: json['docid']! as String,
            name: json['Name']! as String,
            manufacturingdate: json['Manufacturing Date']! as String,
            expirydate: json["Expiry Date"]! as String,
            expirydays: json["Expiry Days"]! as int,
            quantity: json["Quantity"]! as String,
            productimage: json['Product Image']! as String,
            category: json['Category']! as String,
            location: json['Location']! as String,
            additionalinformation: json['Additional Information']! as String,
            uniqueid: json['Uniqueid'] as int);

  final String manufacturingdate;
  final int expirydays;
  final String expirydate;
  final String quantity;
  final String location;
  final String additionalinformation;
  final String category;
  final String productimage;
  final String name;
  final String docid;
  final int uniqueid;

  Map<String, Object?> toJson() {
    return {
      'Doc Id': docid,
      'Name': name,
      'Manufacturing Date': manufacturingdate,
      'Expiry Days': expirydays,
      'Expiry Date': expirydate,
      'Quantity': quantity,
      'Location': location,
      'Additional Information': additionalinformation,
      'Category': category,
      'Product Image': productimage,
      'Uniqueid': uniqueid,
    };
  }
}
