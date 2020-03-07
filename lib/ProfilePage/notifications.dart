import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  static String nameRoute = 'Notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
      ),
    );
  }
}

