import 'package:flutter/material.dart';

class AskCommunityForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
        actions: <Widget>[
          IconButton(
            onPressed: () => null,
            icon: Icon(
              Icons.save,
              color: Color.fromRGBO(10, 17, 40, 1.0),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
