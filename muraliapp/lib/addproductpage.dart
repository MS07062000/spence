import 'dart:core';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:muraliapp/notifications.dart';

class AddproductpageWidget extends StatefulWidget {
  final CupertinoTabController controller;
  final GlobalKey<NavigatorState> navigatorKey;
  const AddproductpageWidget(this.controller, this.navigatorKey);

  @override
  State<AddproductpageWidget> createState() => _Addproduct();
}

class _Addproduct extends State<AddproductpageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
      ),
      body: MyCustomForm(widget.controller, widget.navigatorKey),
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
  final CupertinoTabController controller1;
  final GlobalKey<NavigatorState> navigatorKey1;
  const MyCustomForm(this.controller1, this.navigatorKey1);

  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  @override
  void initState() {
    super.initState();
  }

  File? _pickedImage;
  String? url;
  GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  var date2 = "";
  var date3 = "";
  String unit = 'none';
  String category = "Bakery";
  final _nameofproduct = new TextEditingController();
  final _dateController1 = new TextEditingController();
  final _dateController2 = new TextEditingController();
  final _dateController3 = new TextEditingController();
  final _location = new TextEditingController();
  final _additionalinfo = new TextEditingController();
  final _quantitycontroller = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DateTime day1;
  DateTime? day2;
  DateTime? day3;

  void clearformfield() {
    _formGlobalKey.currentState!.reset();
    _pickedImage = null;
    unit = "none";
    category = "Bakery";
    date2 = "";
    date3 = "";
    _nameofproduct.clear();
    _dateController1.clear();
    _dateController2.clear();
    _dateController3.clear();
    _location.clear();
    _additionalinfo.clear();
    _quantitycontroller.clear();
  }

  showError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: const Text('Please select an image'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok')),
            ],
          );
        });
  }

  void _trysubmit() async {
    bool isvalid;
    isvalid = _formGlobalKey.currentState!.validate();

    if (isvalid) {
      // ignore: non_constant_identifier_names
      int days_calculation(DateTime day1, DateTime expirydate1) {
        day1 = DateTime(day1.year, day1.month, day1.day);
        expirydate1 =
            DateTime(expirydate1.year, expirydate1.month, expirydate1.day);
        final differenceInDays = expirydate1.difference(day1).inDays;
        return differenceInDays;
      }

      try {
        if (_pickedImage == null) {
          showError();
        } else {
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersImages')
              .child(_uid)
              .child(_nameofproduct.text + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();
          int uniqueid =
              DateTime.now().millisecondsSinceEpoch.remainder(100000);
          _formGlobalKey.currentState!.save();
          if (_quantitycontroller.text == "") {
            _quantitycontroller.text = '0';
          }

          Map<String, dynamic> data = {
            "ModifiedName": _nameofproduct.text,
            "Name": _nameofproduct.text,
            "Manufacturing Date": _dateController1.text,
            "Expiry Date": day2 != null
                ? DateFormat('dd/MM/yyyy').format(day2!).toString()
                : DateFormat('dd/MM/yyyy').format(day3!).toString(),
            "Expiry Days": day2 != null
                ? days_calculation(DateTime.now(), day2!)
                : days_calculation(DateTime.now(), day3!),
            "Quantity": _quantitycontroller.text == ""
                ? ('1' + " " + unit)
                : (_quantitycontroller.text + " " + unit),
            'Product Image': url,
            "Category": category,
            "Location": _location.text == "" ? 'None' : _location.text,
            "Additional Information":
                _additionalinfo.text == "" ? 'None' : _additionalinfo.text,
            "Uniqueid": uniqueid,
          };

          FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .collection("user_orders")
              .add(data);
          FirebaseFirestore.instance
              .collection('users')
              .doc(_uid)
              .collection("user_orders")
              .doc("count")
              .update({category: FieldValue.increment(1)});

          String localTimeZone =
              await AwesomeNotifications().getLocalTimeZoneIdentifier();
          if ((day2 != null
                  ? days_calculation(DateTime.now(), day2!)
                  : days_calculation(DateTime.now(), day3!)) <
              2) {
            createExpiryNotification(
                uniqueid,
                _nameofproduct.text,
                NotificationCalendar(
                    timeZone: localTimeZone,
                    year: DateTime.now().year,
                    month: DateTime.now().month,
                    day: DateTime.now().day,
                    hour: DateTime.now().hour,
                    minute: DateTime.now().minute + 2));
          } else {
            createExpiryNotification(
                uniqueid,
                _nameofproduct.text,
                day2 != null
                    ? NotificationCalendar(
                        timeZone: localTimeZone,
                        year: day2!.subtract(const Duration(days: 1)).year,
                        month: day2!.subtract(const Duration(days: 1)).month,
                        day: day2!.subtract(const Duration(days: 1)).day,
                        hour: 10,
                        minute: 0,
                      )
                    : NotificationCalendar(
                        year: day3!.subtract(const Duration(days: 1)).year,
                        month: day3!.subtract(const Duration(days: 1)).month,
                        day: day3!.subtract(const Duration(days: 1)).day,
                        hour: 10,
                        minute: 0,
                        timeZone: localTimeZone));
          }

          if (category == 'Bakery') {
            //_formGlobalKey.currentState!.reset();
            widget.navigatorKey1.currentState!.pushNamed("Bakery");
          } else if (category == 'Dairy') {
            widget.navigatorKey1.currentState!.pushNamed("Dairy");
          } else if (category == 'Medicine') {
            widget.navigatorKey1.currentState!.pushNamed("Medicine");
          } else if (category == 'Frozen Food') {
            widget.navigatorKey1.currentState!.pushNamed("Frozen Food");
          } else {
            widget.navigatorKey1.currentState!.pushNamed("Others");
          }
          clearformfield();
          widget.controller1.index = 0;
        }
      } finally {}
    }
  }

  Future _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedImage == null) return;
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    final pickedImageFile = File(croppedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  Future _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    final pickedImageFile = File(croppedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: CircleAvatar(
                  radius: 71,
                  backgroundColor: Colors.orange,
                  child: CircleAvatar(
                    radius: 68,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: _pickedImage != null
                          ? Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.camera_alt_sharp,
                              size: 70, color: Color.fromRGBO(49, 27, 146, 1)),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 120,
                  left: 110,
                  child: RawMaterialButton(
                    elevation: 10,
                    fillColor: Colors.white,
                    child: const Icon(Icons.add_a_photo),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Choose option',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await _pickImageCamera();
                                        Navigator.of(context).pop();
                                      },
                                      splashColor: Colors.purple,
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.camera,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          Text(
                                            'Camera',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.purple),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _pickImageGallery();
                                        });

                                        Navigator.of(context).pop();
                                      },
                                      splashColor: Colors.purple,
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.purple),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _remove();
                                        });

                                        Navigator.of(context).pop();
                                      },
                                      splashColor: Colors.black,
                                      child: Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ))
            ],
          ),
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
                            _dateController1.text =
                                DateFormat('dd/MM/yyyy').format(day1);
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
                            day2 = selectedDate;
                            _dateController2.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                            date2 = _dateController2.text;
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
                      controller: _dateController3,
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
                            _dateController3.text =
                                DateFormat('MM/yyyy').format(selectedDate);
                            date3 = _dateController3.text;
                            if (selectedDate.month < 12) {
                              day3 = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  DateTime(selectedDate.year,
                                          selectedDate.month + 1, 0)
                                      .day);
                            } else {
                              day3 = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  DateTime(selectedDate.year + 1,
                                          selectedDate.month + 1, 0)
                                      .day);
                            }
                          }
                        });
                      },
                      validator: (date3) {
                        if ((date3 == null || date3.isEmpty) &&
                            (date2.isEmpty)) {
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
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                              decoration: _inputdec("Unit"),
                              value: unit,
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
                          'Bakery',
                          'Dairy',
                          'Medicine',
                          'Frozen Food',
                          'Others',
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
                        style: TextStyle(
                            color: Color.fromRGBO(49, 27, 146, 1),
                            fontSize: 20),
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
        ],
      ),
    );
  }
}
