import 'dart:io';
import 'package:flutter/material.dart';

import 'askCommunityCard.dart';
import 'askCommunityForm.dart';


class QuestionsAsked extends StatefulWidget {
  static String nameRoute = 'AskExpert';

  @override _QuestionsAskedState createState() => _QuestionsAskedState();
}

class _QuestionsAskedState extends State<QuestionsAsked> {
  File file = File(
      '/storage/emulated/0/Android/data/com.example.agrisensor_app/files/Pictures/image_picker7808531823496174987.PNG');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (buildContext, index) {
          return AskCommunityCard(
            file: file,
          );
        },
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            builder: (builder) => AskCommunityForm(),
          ),
        ),
      ),*/
    );
  }
}
