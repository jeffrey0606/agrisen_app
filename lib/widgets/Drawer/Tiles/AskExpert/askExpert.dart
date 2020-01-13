import 'dart:io';
import 'package:flutter/material.dart';

import 'askExpertCard.dart';
import 'askExpertForm.dart';

class AskExpert extends StatefulWidget {
  static String nameRoute = 'AskExpert';

  @override
  _AskExpertState createState() => _AskExpertState();
}

class _AskExpertState extends State<AskExpert> {
  File file = File(
      '/storage/emulated/0/Android/data/com.example.agrisensor_app/files/Pictures/image_picker7808531823496174987.PNG');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Expert'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (buildContext, index) {
          return AskExpertCard(
            file: file,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Ask',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(10, 17, 40, 1.0),
          ),
        ),
        icon: Icon(
          Icons.edit,
          size: 30,
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => AskExpertForm(),
          ),
        ),
      ),
    );
  }
}
