import 'package:flutter/material.dart';
// This is the stateful widget that the main application instantiates.

class CardWidget extends StatefulWidget {
  final String value;
  // ignore: prefer_typing_uninitialized_variables
  final image;
  const CardWidget({Key? key, required this.value, required this.image})
      : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Expanded(
                child: Image.asset(widget.image, fit: BoxFit.cover),
                flex: 2,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(widget.value),
                    subtitle: const Text("Number Items"),
                  ),
                ],
              ),
              flex: 7,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_right_alt_rounded)),
                ],
              ),
              flex: 2,
            ),
          ],
        ),
      ),
      elevation: 8,
      margin: const EdgeInsets.all(10),
      shadowColor: Colors.green,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.green, width: 1)),
    );
  }
}
