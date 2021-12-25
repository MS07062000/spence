import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/dropdownbutton.dart';
import 'package:muraliapp/home.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';

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
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  final formGlobalKey = GlobalKey<FormState>();
  var date2 = "";
  var date3 = "";
  String unit = "";
  String category = "";
  @override
  Widget build(BuildContext context) {
    final _nameofproduct = TextEditingController();
    final _dateController1 = TextEditingController();
    final _dateController2 = TextEditingController();
    final _dateController3 = TextEditingController();
    final _unit1 = TextEditingController();
    final _category1 = TextEditingController();
    final _location = TextEditingController();
    final _additionalinfo = TextEditingController();
    return SingleChildScrollView(
      child: Form(
        key: formGlobalKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 20,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.purple.shade800),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Colors.orange),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 3)),
                  labelText: 'Enter name of product',
                ),
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
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.purple.shade800),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.orange),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 3)),
                    labelText: 'Manufacturing Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
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
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.purple.shade800),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.orange),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 3)),
                    labelText: 'Expiry Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
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
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.purple.shade800),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 3, color: Colors.orange),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 3)),
                    labelText: 'Best Before',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 100,
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.purple.shade800),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: Colors.orange),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: DropDownField(
                        controller: _unit1,
                        hintText: "unit",
                        enabled: true,
                        items: const [
                          'Categories 1',
                          'Categories 2',
                          'Categories 3',
                          'Categories 4'
                        ],
                        onValueChanged: (value) {
                          unit = value;
                        },
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
                child: DropDownField(
                  controller: _category1,
                  hintText: "Select a category",
                  enabled: true,
                  items: const [
                    'Categories 1',
                    'Categories 2',
                    'Categories 3',
                    'Categories 4'
                  ],
                  onValueChanged: (value) {
                    category = value;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 20,
                controller: _location,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.purple.shade800),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Colors.orange),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 3)),
                  labelText: 'Location',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 50,
                controller: _additionalinfo,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 3, color: Colors.purple.shade800),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 3, color: Colors.orange),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 3)),
                  labelText: 'Additional Information',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
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
