import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'askCommunityCard.dart';
import '../CommentingPage/commentingPage.dart';

class QuestionsAsked extends StatefulWidget {
  final Function notYetViewComments;
  QuestionsAsked({@required this.notYetViewComments});
  @override
  _QuestionsAskedState createState() => _QuestionsAskedState();
}

class _QuestionsAskedState extends State<QuestionsAsked> {
  bool once = true, error = false;
  String api_key = '';

  @override
  void didChangeDependencies() async {
    if (once) {
      widget.notYetViewComments();
      await Provider.of<LoadHelps>(context).fetchHelps().catchError((onError) {
        setState(() {
          error = true;
        });
        print('er: $onError');
      });
    }
    once = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadhelps = Provider.of<LoadHelps>(context);
    final helpsData = loadhelps.getHelpsData;
    return error
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                'Oops something went wrong please check your internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  letterSpacing: 2,
                  wordSpacing: 2,
                ),
              ),
            ),
          )
        : CupertinoScrollbar(
            child: helpsData.isEmpty
                ? QuestionAskedSkeletonWidget()
                : helpsData[0] == 'a'
                    ? Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'No help has been asked to the community yet.\n',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18 
                                ),
                              ),
                              TextSpan(
                                text: 'Feel free to ask your first question',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                      key: UniqueKey(),
                        itemCount: helpsData.length,
                        itemBuilder: (buildContext, index) {
                           final profileImage = helpsData[index]['profile_image'];

                print(profileImage);

                var nameInitials = '';
                helpsData[index]['user_name'].split(' ').forEach((f) {
                  if (nameInitials.length == 1) {
                    nameInitials += ' ';
                  }
                  nameInitials += '${f.substring(0, 1)}';
                });
                          return Container(
                            child: AskCommunityCard(
                              cropName: helpsData[index]['crop_name'],
                              profileImage: helpsData[index]['profile_image'],
                              cropImage: json
                                  .decode(helpsData[index]['crop_images'])[0],
                              question: helpsData[index]['question'],
                              timelapse: TimeAjuster.ajust(DateTime.parse(
                                  helpsData[index]['timestamp'])),
                              userName: helpsData[index]['user_name'],
                              askHelpId: helpsData[index]['askHelp_id'],
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CommentingPage.routeName,
                                    arguments: helpsData[index]['askHelp_id']);
                              },
                            ),
                          );
                        },
                      ),
          );
  }
}

class QuestionAskedSkeletonWidget extends StatefulWidget {
  @override
  _QuestionAskedSkeletonWidgetState createState() =>
      _QuestionAskedSkeletonWidgetState();
}

class _QuestionAskedSkeletonWidgetState
    extends State<QuestionAskedSkeletonWidget> {
  
  @override
  void dispose() {
    super.dispose();
    
  }
  
  @override
  void initState() {
    // TODO: implement initState
    startAnimation();
    super.initState();
  }

  bool _animateOpacity = true, val = true;
  
  startAnimation() {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _animateOpacity = !_animateOpacity;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget text(EdgeInsetsGeometry margin) {
    return Container(
      //height: 15,
      //width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List temp = List(3);
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: temp.map((articleData) {
          return Container(
            margin: EdgeInsets.only(top: 5.0, left: 0, right: 0, bottom: 5),
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 340,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity:
                        _animateOpacity ? (val ? 0.4 : 0.8) : (val ? 0.8 : 0.4),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(60),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 15,
                                          width: width * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 15,
                                          width: width * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 15,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 15,
                                      width: width * 0.4,
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '?',
                                      style: TextStyle(
                                        color: Colors.black12,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: width * 0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(60),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            width: width * 0.3,
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          )
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
        }).toList(),
      ),
    );
  }
}
