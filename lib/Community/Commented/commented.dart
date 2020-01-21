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
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/backiee-117476-landscape.jpg'),
                    maxRadius: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'What\'s the problem with this my tomato leaves. It has black spots on it?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tomato fruit',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(3),
                                constraints: BoxConstraints(
                                  minWidth: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                    25,
                                  ),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    '4',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
