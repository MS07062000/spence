import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/dropdownbutton.dart';
import 'package:muraliapp/home.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddproductpageWidget extends StatefulWidget {
  const AddproductpageWidget({Key? key}) : super(key: key);

  @override
  State<AddproductpageWidget> createState() => _Addproduct();
}

class _Addproduct extends State<AddproductpageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Product'),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWidget()),
              );*/
              Navigator.pop(context);
            },
          )),
      body: const MyCustomForm(),
    );
  }
}

_inputdec(String text) {
  return InputDecoration(
    counterText: "",
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.purple.shade800),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    labelText: text,
  );
}

_inputdec2(String text, IconData text2) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.purple.shade800),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 2, color: Colors.orange),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2)),
    labelText: text,
    suffixIcon: Icon(text2),
  );
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  var date2 = "";
  var date3 = "";
  String unit = "Android";
  String category = "Android";
  final _nameofproduct = TextEditingController();
  final _dateController1 = TextEditingController();
  final _dateController2 = TextEditingController();
  final _dateController3 = TextEditingController();
  final _location = TextEditingController();
  final _additionalinfo = TextEditingController();
  final _quantitycontroller = TextEditingController();

  void _trysubmit() async {
    bool isvalid;
    isvalid = _formGlobalKey.currentState!.validate();

    if (isvalid) {
      String expirydate(String datex, String datey) {
        if (datex.isEmpty || datex == null) {
          return datey;
        }
        return datex;
      }

      _formGlobalKey.currentState!.save();
      Map<String, dynamic> data = {
        "Name": _nameofproduct.text,
        "Manufacturing Date": _dateController1.text,
        "Expiry Date": expirydate(date2, date3),
        "Quantity": _quantitycontroller.text + unit,
        "Category": category,
        "Location": _location.text,
        "Additional Information": _additionalinfo.text,
      };
      FirebaseFirestore.instance.collection("test").add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
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
                controller: _nameofproduct,
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
                  controller: _dateController1,
                  decoration:
                      _inputdec2('Manufacturing Date', Icons.calendar_today),
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        _dateController1.text =
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
                  controller: _dateController2,
                  decoration: _inputdec2('Expiry Date', Icons.calendar_today),
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        _dateController2.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                        date2 = _dateController2.text;
                      }
                    });
                  },
                  validator: (date_2) {
                    if (date_2 == null ||
                        date_2.isEmpty ||
                        date3 == null ||
                        date3.isEmpty) {
                      return 'Please enter expiry date.';
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
                  controller: _dateController3,
                  decoration: _inputdec2('Best Before', Icons.calendar_today),
                  onTap: () async {
                    await showMonthPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        _dateController3.text =
                            DateFormat('MM/yyyy').format(selectedDate);
                        date3 = _dateController3.text;
                      }
                    });
                  },
                  validator: (date3) {
                    if (date3 == null ||
                        date3.isEmpty ||
                        date2 == null ||
                        date2.isEmpty) {
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
                          controller: _quantitycontroller,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: _inputdec("unit"),
                          value: unit,
                          style: const TextStyle(color: Colors.black),
                          items: <String>[
                            'Android',
                            'IOS',
                            'Flutter',
                            'Node',
                            'Java',
                            'Python',
                            'PHP',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                    value: category,
                    hint: const Text(
                      "Select Item Type",
                      style: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(color: Colors.black),
                    items: <String>[
                      'Android',
                      'IOS',
                      'Flutter',
                      'Node',
                      'Java',
                      'Python',
                      'PHP',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                  controller: _location,
                  decoration: _inputdec("Location")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  controller: _additionalinfo,
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
                    'Add Product',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
          ],
        ),
      ),
    );
  }
}
