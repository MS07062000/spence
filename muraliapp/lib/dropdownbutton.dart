import 'package:flutter/material.dart';
// This is the stateful widget that the main application instantiates.

class DropDownButton extends StatefulWidget {
  final String value;
  final Iterable<String> values;
  const DropDownButton({Key? key, required this.value, required this.values})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState(value, values);
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<DropDownButton> {
  String value;
  Iterable<String> values;
  _MyStatefulWidgetState(this.value, this.values); //constructor
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          value = newValue!;
        });
      },
      items: (values).map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
