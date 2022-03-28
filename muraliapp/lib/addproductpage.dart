import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muraliapp/global_method.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:muraliapp/home.dart';
import 'package:muraliapp/home2.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muraliapp/login_signup_widgets/login.dart';
import 'package:timezone/timezone.dart' as tz;

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
          title: const Text(
            'Add Product',
            style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
          ),
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Homepage2Widget()),
              );*/
              Navigator.of(context).pop();
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
  late FlutterLocalNotificationsPlugin fltrNotifications;
  @override
  void initState() {
    super.initState();
    var androidInitilize = const AndroidInitializationSettings('app_icon');
    var iOSinitilize = const IOSInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    fltrNotifications = FlutterLocalNotificationsPlugin();
    fltrNotifications.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected());
  }

  File? _pickedImage;
  String? url;
  final _formGlobalKey = GlobalKey<FormState>();
  var date2 = "";
  var date3 = "";
  String unit = "Android";
  String category = "Bakery";
  final _nameofproduct = TextEditingController();
  final _dateController1 = TextEditingController();
  final _dateController2 = TextEditingController();
  final _dateController3 = TextEditingController();
  final _location = TextEditingController();
  final _additionalinfo = TextEditingController();
  final _quantitycontroller = TextEditingController();
  final GlobalMethods _globalMethods = GlobalMethods();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DateTime day1;
  DateTime? day2;
  DateTime? day3;

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
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {});
          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersImages')
              .child(_uid)
              .child(_nameofproduct.text + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();
          int uniqueid = DateTime.now().millisecondsSinceEpoch;
          _formGlobalKey.currentState!.save();
          Map<String, dynamic> data = {
            "Name": _nameofproduct.text,
            "Manufacturing Date": _dateController1.text,
            "Expiry Date": day2 != null
                ? DateFormat('dd/MM/yyyy').format(day2!).toString()
                : DateFormat('dd/MM/yyyy').format(day3!).toString(),
            "Expiry Days": day2 != null
                ? days_calculation(DateTime.now(), day2!)
                : days_calculation(DateTime.now(), day3!),
            "Quantity": _quantitycontroller.text + " " + unit,
            'Product Image': url,
            "Category": category,
            "Location": _location.text,
            "Additional Information": _additionalinfo.text,
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
              .update({data[category]: FieldValue.increment(1)});
          _showNotification(
              uniqueid,
              _nameofproduct.text,
              day2 != null
                  ? days_calculation(DateTime.now(), day2!)
                  : days_calculation(DateTime.now(), day3!));
          Navigator.canPop(context) ? Navigator.pop(context) : null;
          _formGlobalKey.currentState!.reset();
        }
      } finally {
        setState(() {});
      }
    }
  }

  Future _showNotification(int id, String name, int exday) async {
    var androidDetails = const AndroidNotificationDetails(
        "Channel ID", "Channel name",
        importance: Importance.max);
    var iSODetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);

    fltrNotifications.zonedSchedule(
        id,
        'Expiring Tomorrow',
        'Your product ' +
            name +
            ' is going to be expired tomorrow. Please use it today or remove it.',
        tz.TZDateTime.now(tz.local).add(Duration(days: exday - 2, hours: 10)),
        generalNotificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
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
                          : Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                              fit: BoxFit.cover,
                            ),
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
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2025),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            day1 = selectedDate;
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
                      decoration:
                          _inputdec2('Expiry Date', Icons.calendar_today),
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
                      controller: _dateController3,
                      decoration:
                          _inputdec2('Best Before', Icons.calendar_today),
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
                              decoration: _inputdec("Unit"),
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

  notificationSelected() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Homepage2Widget()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }
}
