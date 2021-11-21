import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

//in pubsecyaml add karna tabhi run karega month_picker_dialog: ^0.4.0
class DatePickerWidget2 extends StatefulWidget {
  const DatePickerWidget2({Key? key}) : super(key: key);
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget2> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      //return DateFormat('dd/MM/yyyy').format(date);
      return '${date?.month}/${date?.year}';
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
    final newDate = await showMonthPicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}
