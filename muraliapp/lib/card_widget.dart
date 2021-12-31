import 'package:flutter/material.dart';
// This is the stateful widget that the main application instantiates.

class CardWidget extends StatefulWidget {
  final String value;
  final String image;
  final screen_name;
  const CardWidget(
      {Key? key,
      required this.value,
      required this.image,
      required this.screen_name})
      : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => widget.screen_name));
                      },
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
      shadowColor: Colors.orange,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange, width: 1)),
    );
  }
}
