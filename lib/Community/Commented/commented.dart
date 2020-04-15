import 'dart:convert';

import 'package:agrisen_app/Community/Commented/comentedCard.dart';
import 'package:agrisen_app/Community/CommentingPage/commentingPage.dart';
import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/imagesViewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Commented extends StatefulWidget {
  final Function setAlreadyView;
  Commented({@required this.setAlreadyView});
  @override
  _CommentedState createState() => _CommentedState();
}

class _CommentedState extends State<Commented> {
  bool once = true;
  Future _commentedHelps;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      widget.setAlreadyView();
      _commentedHelps = getCommentedHelps();
    }
    print(once);
    once = false;
  }

  getCommentedHelps() async {
    final url =
        'http://192.168.43.150/agrisen-api/index.php/Community/fetch_commented_helps';
    final userProvider = Provider.of<UserInfos>(context);
    if (userProvider.userInfos['api_key'] == null) {
      await userProvider.getUser();
      return http
            .get(url, headers: {'api_key': userProvider.userInfos['api_key']});
    } else {
      return http
          .get(url, headers: {'api_key': userProvider.userInfos['api_key']});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _commentedHelps,
      builder: (BuildContext buildContext, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: Card(
                elevation: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              http.Response data = snapshot.data;
              final commentedHelps =
                  data.body.toString().isEmpty ? null : json.decode(data.body) as List<dynamic>;
                  print(commentedHelps);
              if (commentedHelps != null && commentedHelps.isNotEmpty) {
                return CupertinoScrollbar(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: ListView.separated(
                      itemCount: commentedHelps.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                        indent: MediaQuery.of(context).size.width * 0.26,
                      ),
                      itemBuilder: (context, index) {
                        return CommentedCard(
                          cropName: commentedHelps[index]['crop_name'],
                          question:
                              commentedHelps[index]['question'].endsWith('?')
                                  ? commentedHelps[index]['question']
                                  : '${commentedHelps[index]['question']} ?',
                          images:
                              json.decode(commentedHelps[index]['crop_images']),
                          askHelpId: int.parse(commentedHelps[index]['askHelp_id']),
                          lastTimestamp: DateTime.parse(
                              commentedHelps[index]['last_timestamp']),
                          userId: Provider.of<UserInfos>(context).userInfos['user_id'],
                        );
                      },
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              print('custom err: ${snapshot.error}');
            }
            return Center(
              child: Text('Oops no data available yet!'),
            );
          default:
            return Container();
        }
      },
    );
  }
}
