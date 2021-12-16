import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/dropdownbutton.dart';
import 'package:muraliapp/home.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddproductpageWidget extends StatefulWidget {
  const AddproductpageWidget({Key? key}) : super(key: key);

  @override
  State<AddproductpageWidget> createState() => _Addproduct();
}

class _Addproduct extends State<AddproductpageWidget> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Add Product';
    return Scaffold(
      appBar: AppBar(
          title: const Text(appTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWidget()),
              );
            },
          )),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateController1 = TextEditingController();
    final _dateController2 = TextEditingController();
    final _dateController3 = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter name of product',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Manufacturing Date',
                suffixIcon: Icon(Icons.calendar_today),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter date.';
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expiry Date',
                suffixIcon: Icon(Icons.calendar_today),
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
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter date.';
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Best Before',
                suffixIcon: Icon(Icons.calendar_today),
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
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select month or expiry date.';
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
                  children: const [Text("Quantity")],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    DropDownButton(
                      value: "Categories 1",
                      values: [
                        'Categories 1',
                        'Categories 2',
                        'Categories 3',
                        'Categories 4'
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            child: const DropdownButtonHideUnderline(
              child: DropDownButton(
                value: "Categories 1",
                values: [
                  'Categories 1',
                  'Categories 2',
                  'Categories 3',
                  'Categories 4'
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Location',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Additional Information',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            // height: double.infinity,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Add Product',
              ),
              style: TextButton.styleFrom(
                  primary: Colors.purple,
                  backgroundColor: Colors.amber,
                  textStyle: const TextStyle(fontSize: 24)),
            ),
          ),
        ),
      ],
    );
  }
}
