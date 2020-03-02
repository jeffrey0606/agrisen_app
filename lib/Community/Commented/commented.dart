import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Commented extends StatefulWidget {
  @override
  _CommentedState createState() => _CommentedState();
}

class _CommentedState extends State<Commented> {
  bool once = true;
  String userId = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      final sharedPref = await SharedPreferences.getInstance();

      if (sharedPref.containsKey('userInfos')) {
        final userinfos = json.decode(sharedPref.getString('userInfos'));
        await Provider.of<LoadCommentedHelps>(context, listen: false)
            .fechCommentedHelps(userinfos['api-key']);
      }
    }
    once = false;
  }

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
    final commentedHelps =
        Provider.of<LoadCommentedHelps>(context).commentedHelps();

    return commentedHelps.isEmpty
        ? Center(
            child: Text('Oops no data available yet!'),
          )
        : Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: ListView.separated(
              itemCount: commentedHelps.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
                indent: MediaQuery.of(context).size.width * 0.26,
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
                              NetworkImage('http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${commentedHelps[index]['crop_image']}'),
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
                                commentedHelps[index]['question'].endsWith('?')
                                    ? commentedHelps[index]['question']
                                    : '${commentedHelps[index]['question']} ?',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    commentedHelps[index]['crop_name'],
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
