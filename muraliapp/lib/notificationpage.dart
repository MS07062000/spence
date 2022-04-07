import 'package:flutter/material.dart';

class notificationpageWidget extends StatefulWidget {
  const notificationpageWidget({Key? key}) : super(key: key);

  @override
  State<notificationpageWidget> createState() => _notificationpage();
}

class _notificationpage extends State<notificationpageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(color: Color.fromRGBO(49, 27, 146, 1)),
        ),
        backgroundColor: Colors.orange,
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  State<MyCustomForm> createState() => _MyCustomStatefulWidgetState();
}

class _MyCustomStatefulWidgetState extends State<MyCustomForm> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
