import 'package:flutter/material.dart';
import 'package:muraliapp/dropdownbutton.dart';

class ExpiringsoonpageWidget extends StatefulWidget {
  const ExpiringsoonpageWidget({Key? key}) : super(key: key);

  @override
  State<ExpiringsoonpageWidget> createState() => _Expiringsoon();
}

class _Expiringsoon extends State<ExpiringsoonpageWidget> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Expiring soon';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: DropDownButton(
              value: 'Within a day',
              values: ['Within a day', 'Within a week', 'Within a month']),
        ),
      ],
    );
  }
}
