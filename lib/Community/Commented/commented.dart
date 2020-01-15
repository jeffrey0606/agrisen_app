import 'package:flutter/material.dart';

class Commented extends StatefulWidget {
  @override
  _CommentedState createState() => _CommentedState();
}

class _CommentedState extends State<Commented> {

  Future<void> delete(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(
            'Delete',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
          ),
          content: Text(
              'Are you sure you want to completely delete this Question ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () => null,
            ),
            FlatButton(
              color: Colors.blue,
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index){
        return ListTile(
          onTap: () => null,
        );
      },
    );
  }
}