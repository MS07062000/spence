import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Card2Widget extends StatefulWidget {
  final String name;
  final String date;
  final String quantity;
  final String image;
  const Card2Widget({
    Key? key,
    required this.image,
    required this.name,
    required this.date,
    required this.quantity,
  }) : super(key: key);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<Card2Widget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Expanded(
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                  flex: 2,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      "Expires in" + widget.date + "days",
                      style: const TextStyle(color: Colors.red),
                    ),
                    Text(
                      widget.quantity,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    color: Colors.orange,
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  IconButton(
                    color: Colors.orange,
                    onPressed: () {},
                    icon: const Icon(Icons.find_replace_sharp),
                  )
                ],
              ),
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
