import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AskExpertCard extends StatelessWidget {
  final File file;
  AskExpertCard({this.file});

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
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 0, right: 0, bottom: 10),
      child: Card(
        child: InkWell(
          onTap: () => null,
          onLongPress: () => delete(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 350,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Colors.blue,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Herve Niko',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    '5  d',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'What\'s the problem with this my tomato leaves. It has black spots on it?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Tomato fruit',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () => null,
                                      icon: Icon(Icons.thumb_up),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    IconButton(
                                      onPressed: () => null,
                                      icon: Icon(Icons.thumb_down),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      maxRadius: 10.0,
                                      child: FittedBox(
                                        child: Text(
                                          '5',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Discussions',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
