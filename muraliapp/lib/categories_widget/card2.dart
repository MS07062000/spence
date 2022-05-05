import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/notificationapi.dart';
import 'package:muraliapp/updateproductpage.dart';

class Card2Widget extends StatefulWidget {
  final String docid;
  final String name;
  final String modifiedname;
  final String expirydate;
  final String quantity;
  final String image;
  final String manufacturingdate;
  final int expirydays;
  final String location;
  final String additionalinformation;
  final String category;
  final int uniqueid;

  const Card2Widget({
    Key? key,
    required this.docid,
    required this.image,
    required this.name,
    required this.modifiedname,
    required this.expirydate,
    required this.quantity,
    required this.manufacturingdate,
    required this.expirydays,
    required this.location,
    required this.additionalinformation,
    required this.category,
    required this.uniqueid,
  }) : super(key: key);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<Card2Widget> {
  Color getColour() {
    if (widget.expirydays > 30 && widget.expirydays < 90) {
      return Colors.teal.shade800;
    } else if (widget.expirydays > 90 && widget.expirydays < 120) {
      return Colors.green.shade800;
    } else if (widget.expirydays > 180 && widget.expirydays < 365) {
      return Colors.blue;
    } else if (widget.expirydays > 365) {
      return Colors.pink.shade800;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: false,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        )),
        //borderSide: BorderSide(color: Colors.orange, width: 1))),
        child: Container(
          height: 106,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.network(widget.image, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Expires in " + widget.expirydays.toString() + " days",
                        style: TextStyle(color: getColour()),
                      ),
                      Text(
                        widget.quantity,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  CupertinoButton(
                    minSize: double.minPositive,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              insetPadding: EdgeInsets.all(5),
                              elevation: 8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      child: Text(
                                    "Details",
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 20),
                                  )),
                                  Container(
                                    child: Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(0.5),
                                        1: FractionColumnWidth(0.5),
                                      },
                                      defaultVerticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        buildRow(
                                            [' Name:', widget.name.toString()]),
                                        buildRow([
                                          ' Manufatcuring Date:',
                                          widget.manufacturingdate.toString()
                                        ]),
                                        buildRow([
                                          ' Expiry Date:',
                                          widget.expirydate.toString()
                                        ]),
                                        buildRow([
                                          ' Quantity:',
                                          widget.quantity.toString()
                                        ]),
                                        buildRow([
                                          ' Location:',
                                          widget.location.toString()
                                        ]),
                                        buildRow([
                                          ' Additional Information:',
                                          widget.additionalinformation
                                              .toString()
                                        ]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.orange,
                    ),
                  ),
                  CupertinoButton(
                    minSize: double.minPositive,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateproductpageWidget(
                                    modifiedname: widget.modifiedname,
                                    name: widget.name,
                                    manufacturingdate: widget.manufacturingdate,
                                    expirydays: widget.expirydays,
                                    expirydate: widget.expirydate,
                                    quantity: widget.quantity,
                                    location: widget.location,
                                    additionalinformation:
                                        widget.additionalinformation,
                                    category: widget.category,
                                    docid: widget.docid,
                                    uniqueid: widget.uniqueid,
                                  )));
                    },
                    child: const Icon(Icons.edit, color: Colors.orange),
                  ),
                  CupertinoButton(
                    minSize: double.minPositive,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      showError();
                    },
                    child: const Icon(Icons.delete, color: Colors.orange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      elevation: 0,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5.0, bottom: 5.0),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //borderSide: const BorderSide(color: Colors.orange, width: 1)),
    );
  }

  Future<void> deleteUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc(widget.docid)
        .delete();

    NotificationApi.cancel(widget.uniqueid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("user_orders")
        .doc("count")
        .update({widget.category: FieldValue.increment(-1)});
    return FirebaseStorage.instance
        .ref()
        .child('usersImages')
        .child(_uid)
        .child(widget.modifiedname + '.jpg')
        .delete();
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
                  child: const Text('Yes',
                      style: TextStyle(color: Colors.orange))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('No', style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  TableRow buildRow(List<String> cells) => TableRow(
        children: cells
            .map((cell) => Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  cell,
                  textAlign: TextAlign.left,
                )))
            .toList(),
      );
}
