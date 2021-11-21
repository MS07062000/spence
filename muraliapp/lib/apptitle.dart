import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class AppTitleBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppTitleBarWidget({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('AppBar Demo'),
      backgroundColor: Colors.blue,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {},
        ),
      ],
    );
  }
}
