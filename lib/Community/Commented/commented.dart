import 'dart:convert';

import 'package:agrisen_app/Community/CommentingPage/commentingPage.dart';
import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/imagesViewer.dart';
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
  String apiKey = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      final sharedPref = await SharedPreferences.getInstance();

      if (sharedPref.containsKey('userInfos')) {
        final userinfos = json.decode(sharedPref.getString('userInfos'));
        _fechCommentedHelps(userinfos['api-key']);
        setState(() {
          apiKey = userinfos['api-key'];
        });
      }
    }
    print(once);
    once = false;
  }

  void _fechCommentedHelps(String apiKey) async {
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechCommentedHelps(apiKey);
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechNotYetViewedComments(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    final commentedHelps =
        Provider.of<LoadCommentedHelps>(context).getCommentedHelps;
    final notYetViewedComments =
        Provider.of<LoadCommentedHelps>(context).getNotYetViewedComments;

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
                final images =
                    json.decode(commentedHelps[index]['crop_images']);
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CommentingPage.routeName,
                        arguments: commentedHelps[index]['askHelp_id']);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              ImagesViewer.namedRoute,
                              arguments: {'from': 'network', 'images': images}),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${images[0]}'),
                            maxRadius: 40,
                          ),
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
                                  if (notYetViewedComments.isNotEmpty && notYetViewedComments[commentedHelps[index]['askHelp_id']] != null)
                                  SizedBox(
                                    height: 30,
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(3),
                                        constraints: BoxConstraints(
                                          minWidth: 30,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            'NEW ' +
                                                notYetViewedComments[
                                                        commentedHelps[index]
                                                            ['askHelp_id']]
                                                    .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
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
