import 'package:flutter/material.dart';
import 'package:muraliapp/card_widget.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({Key? key}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _Homepage();
}

class _Homepage extends State<HomepageWidget> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Spence';
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
    return SingleChildScrollView(
      child: Column(
        children: const [
          CardWidget(value: "Bakery", image: 'assets/images/bakery.png'),
          CardWidget(value: "Dairy", image: 'assets/images/bakery.png'),
          CardWidget(value: "Medicine", image: 'assets/images/bakery.png'),
          CardWidget(value: "Frozen Food", image: 'assets/images/bakery.png'),
          CardWidget(value: "Others", image: 'assets/images/bakery.png'),
        ],
      ),
    );
  }
}
