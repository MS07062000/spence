import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muraliapp/notificationapi.dart';

class UpdateproductpageWidget extends StatefulWidget {
  final String manufacturingdate;
  final int expirydays;
  final String expirydate;
  final String quantity;
  final String location;
  final String additionalinformation;
  final String category;
  final String name;
  final String docid;
  final int uniqueid;
  final String modifiedname;

  const UpdateproductpageWidget(
      {Key? key,
      required this.docid,
      required this.name,
      required this.manufacturingdate,
      required this.expirydate,
      required this.location,
      required this.additionalinformation,
      required this.category,
      required this.expirydays,
      required this.quantity,
      required this.modifiedname,
      required this.uniqueid})
      : super(key: key);

  @override
  State<UpdateproductpageWidget> createState() => _Updateproduct();
}

class _Updateproduct extends State<UpdateproductpageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Update Product',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: MyCustomForm(
        manufacturingdate_1: widget.manufacturingdate,
        expirydays_1: widget.expirydays,
        expirydate_1: widget.expirydate,
        quantity_1: widget.quantity,
        location_1: widget.location,
        additionalinformation_1: widget.additionalinformation,
        category_1: widget.category,
        name_1: widget.name,
        docid_1: widget.docid,
        uniqueid_1: widget.uniqueid,
        modifiedname_1: widget.modifiedname,
      ),
    );
  }
}

_inputdec(String text) {
  return InputDecoration(
    floatingLabelStyle: const TextStyle(color: Colors.orange),
    counterText: "",
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1)),
    labelText: text,
  );
}

_inputdec2(String text, IconData text2) {
  return InputDecoration(
    floatingLabelStyle: const TextStyle(color: Colors.orange),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1)),
    labelText: text,
    suffixIcon: Icon(text2, color: Colors.orange),
  );
}

class MyCustomForm extends StatefulWidget {
  final String manufacturingdate_1;
  final int expirydays_1;
  final String expirydate_1;
  final String quantity_1;
  final String location_1;
  final String additionalinformation_1;
  final String category_1;
  final String modifiedname_1;
  final String name_1;
  final String docid_1;
  final int uniqueid_1;

  const MyCustomForm(
      {Key? key,
      required this.docid_1,
      required this.uniqueid_1,
      required this.name_1,
      required this.modifiedname_1,
      required this.manufacturingdate_1,
      required this.expirydate_1,
      required this.location_1,
      required this.additionalinformation_1,
      required this.category_1,
      required this.expirydays_1,
      required this.quantity_1})
      : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  var date2 = "";
  var date3 = "";
  late String unit;
  late String category;
  late TextEditingController nameofproduct;
  late TextEditingController dateController1;
  late TextEditingController dateController2;
  TextEditingController dateController3 = TextEditingController();
  late TextEditingController location;
  late TextEditingController additionalinfo;
  late TextEditingController quantitycontroller;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DateTime day1;
  DateTime? day2;
  DateTime? day3;

  @override
  void initState() {
    super.initState();
    nameofproduct = TextEditingController();
    dateController1 = TextEditingController();
    dateController2 = TextEditingController();
    location = TextEditingController();
    additionalinfo = TextEditingController();
    quantitycontroller = TextEditingController();
    nameofproduct.text = widget.name_1;
    location.text = widget.location_1;
    additionalinfo.text = widget.additionalinformation_1;
    quantitycontroller.text = widget.quantity_1.split(' ')[0];
    unit = widget.quantity_1.split(' ')[1];
    category = widget.category_1;
    dateController1.text = widget.manufacturingdate_1;
    dateController2.text = widget.expirydate_1;
  }

  void _trysubmit() async {
    bool isvalid;
    isvalid = _formGlobalKey.currentState!.validate();

    if (isvalid) {
      String expirydate(String datex, String datey) {
        if (datex.isEmpty) {
          return datey;
        }
        return datex;
      }

      // ignore: non_constant_identifier_names
      int days_calculation(DateTime day1, DateTime expirydate1) {
        day1 = DateTime(day1.year, day1.month, day1.day);
        expirydate1 =
            DateTime(expirydate1.year, expirydate1.month, expirydate1.day);
        final differenceInDays = expirydate1.difference(day1).inDays;
        return differenceInDays;
      }

      // ignore: non_constant_identifier_names
      int days_calculation2(DateTime day1, DateTime expirydate1) {
        day1 = DateTime(day1.year, day1.month, day1.day);
        expirydate1 = DateTime(expirydate1.year, expirydate1.month,
            DateTime(expirydate1.year, expirydate1.month + 1, 0).day);
        final differenceInDays = expirydate1.difference(day1).inDays;
        return differenceInDays;
      }

      try {
        setState(() {});
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .collection("user_orders")
            .doc(widget.docid_1)
            .update({
          "ModifiedName": widget.modifiedname_1,
          "Name": nameofproduct.text,
          "Manufacturing Date": dateController1.text,
          "Expiry Date": expirydate(date2, date3),
          "Expiry Days": day2 != null
              ? days_calculation(DateTime.now(), day2!)
              : days_calculation2(DateTime.now(), day3!),
          "Quantity": quantitycontroller.text + " " + unit,
          "Category": category,
          "Location": location.text,
          "Additional Information": additionalinfo.text,
          "Uniqueid": widget.uniqueid_1,
        });

        if ((day2 != null
                ? days_calculation(DateTime.now(), day2!)
                : days_calculation(DateTime.now(), day3!)) <
            2) {
          NotificationApi.showScheduledNotification(
              id: widget.uniqueid_1,
              title: "Expiring Tomorrow",
              body: 'Your product ' +
                  nameofproduct.text +
                  ' is going to be expired tomorrow. Please use it today or remove it.',
              scheduledDate: DateTime.now().add(Duration(minutes: 2)));
          print(DateTime.now().add(Duration(minutes: 2)));
        } else {
          NotificationApi.showScheduledNotification(
              id: widget.uniqueid_1,
              title: "Expiring Tomorrow",
              body: 'Your product ' +
                  nameofproduct.text +
                  ' is going to be expired tomorrow. Please use it today or remove it.',
              scheduledDate: day2 != null
                  ? DateTime(
                      day2!.subtract(const Duration(days: 1)).year,
                      day2!.subtract(const Duration(days: 1)).month,
                      day2!.subtract(const Duration(days: 1)).day,
                      10,
                      0,
                      0,
                      0)
                  : DateTime(
                      day3!.subtract(const Duration(days: 1)).year,
                      day3!.subtract(const Duration(days: 1)).month,
                      day3!.subtract(const Duration(days: 1)).day,
                      10,
                      0,
                      0,
                      0));
          print(day2 != null
              ? DateTime(
                  day2!.subtract(const Duration(days: 1)).year,
                  day2!.subtract(const Duration(days: 1)).month,
                  day2!.subtract(const Duration(days: 1)).day,
                  10,
                  0,
                  0,
                  0)
              : DateTime(
                  day3!.subtract(const Duration(days: 1)).year,
                  day3!.subtract(const Duration(days: 1)).month,
                  day3!.subtract(const Duration(days: 1)).day,
                  10,
                  0,
                  0,
                  0));
        }

        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } finally {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    decoration: _inputdec("Enter name of product"),
                    controller: nameofproduct,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Please enter name of product';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: TextFormField(
                      readOnly: true,
                      controller: dateController1,
                      decoration: _inputdec2(
                          'Manufacturing Date', Icons.calendar_today),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            day1 = selectedDate;
                            dateController1.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                          }
                        });
                      },
                      validator: (date1) {
                        if (date1 == null || date1.isEmpty) {
                          return 'Please enter manufacturing date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: TextFormField(
                      readOnly: true,
                      controller: dateController2,
                      decoration:
                          _inputdec2('Expiry Date', Icons.calendar_today),
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            dateController2.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                            date2 = dateController2.text;
                            day2 = selectedDate;
                          }
                        });
                      },

                      /*validator: (date_2) {
                        if (date_2 == null ||
                            date_2.isEmpty ||
                            date3 == null ||
                            date3.isEmpty) {
                          return 'Please enter expiry date.';
                        }
                        return null;
                      },*/
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "OR",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: TextFormField(
                      readOnly: true,
                      controller: dateController3,
                      decoration:
                          _inputdec2('Best Before', Icons.calendar_today),
                      onTap: () async {
                        await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 5),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            dateController3.text =
                                DateFormat('MM/yyyy').format(selectedDate);
                            date3 = dateController3.text;
                            day3 = selectedDate;
                          }
                        });
                      },
                      validator: (date3) {
                        if (dateController2.text.isNotEmpty) {
                          date2 = dateController2.text;
                          day2 = DateTime(
                              int.parse(date2.substring(6)),
                              int.parse(date2.substring(3, 5)),
                              int.parse(date2.substring(0, 2)));
                        }

                        if ((date3 == null || date3.isEmpty) && date2.isEmpty) {
                          return 'Please select best before month or expiry date.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 100,
                              decoration: _inputdec("Quantity"),
                              controller: quantitycontroller,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              decoration: _inputdec("Unit"),
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                              style: const TextStyle(color: Colors.black),
                              items: <String>[
                                'kg',
                                'g',
                                'lt',
                                'ml',
                                'lb',
                                'oz',
                                'quart',
                                'gallon',
                                'piece',
                                'pack',
                                'bottle',
                                'jar',
                                'can',
                                'box',
                                'bag',
                                'table',
                                'tube',
                                'roll',
                                'none',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: unit,
                              onChanged: (value) {
                                setState(() {
                                  unit = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: _inputdec("Category"),
                        hint: const Text(
                          "Select Item Type",
                          style: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(color: Colors.black),
                        items: <String>[
                          'Bakery',
                          'Dairy',
                          'Medicine',
                          'Frozen Food',
                          'Others',
                          'Condiments',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: category,
                        onChanged: (String? value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      controller: location,
                      decoration: _inputdec("Location")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      controller: additionalinfo,
                      decoration: _inputdec("Additional Information")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _trysubmit,
                      child: const Text(
                        'Update Product',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.green;
                            }
                            return Colors.orange;
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
