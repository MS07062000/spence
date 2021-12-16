import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({Key? key}) : super(key: key);
  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      return '${date?.day}/${date?.month}/${date?.year}';
    }
  }

  @override
  Widget build(BuildContext context) => TextButton(
        child: FittedBox(
          child: Row(
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Text(
                getText(),
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(Icons.calendar_today)
            ],
          ),
        ),
        onPressed: () => _pickDate(context),
      );

  Future<void> _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  String sendtext() {
    return getText();
  }
}
