import 'dart:convert';

import 'package:agrisen_app/Community/CommentingPage/commentingPage.dart';
import 'package:flutter/material.dart';

import '../../imagesViewer.dart';
import 'package:http/http.dart' as http;

class CommentedCard extends StatefulWidget {
  final int askHelpId;
  final List<dynamic> images;
  final String question;
  final String cropName;
  final DateTime lastTimestamp;
  final String userId;
  CommentedCard({this.askHelpId, this.cropName, this.images, this.lastTimestamp, this.question, this.userId});
  @override
  _CommentedCardState createState() => _CommentedCardState();
}

class _CommentedCardState extends State<CommentedCard> {
  int number = 0;

  Future getNumberOfCommentsNotYetViewedForAskHelps(
      int askHelpId, DateTime lastTimestamp, String userId) async {
    await http.post(
        'http://192.168.43.150/agrisen-api/index.php/Community/ask_helps_number_of_not_yet_view_comments',
        body: {
          'askHelp_id': json.encode(askHelpId),
          'comment_timestamp': lastTimestamp.toString(),
          'user_id': userId,
        }).then((response) {
      setState(() {
        print('$askHelpId : $lastTimestamp');
        print(json.decode(response.body));
        number = json.decode(response.body);
      });
    }).catchError((onError) {
      print('e: $onError');
    });
  }
  bool once = true;

  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    if(once){
      await  getNumberOfCommentsNotYetViewedForAskHelps(widget.askHelpId, widget.lastTimestamp, widget.userId);
    }
    once = false;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, CommentingPage.routeName,
                              arguments: widget.askHelpId
                                  .toString());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    ImagesViewer.namedRoute,
                                    arguments: {
                                      'from': 'network',
                                      'images': widget.images
                                    }),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'http://192.168.43.150/agrisen-api/uploads/ask_helps/${widget.images[0]}',
                                  ),
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
                                      widget.question,
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
                                          widget.cropName,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: Card(
                                            elevation: 2,
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
                                                color: number == 0 ? Colors.green : Colors.red,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                              ),
                                              child: FittedBox(
                                                child: Text(
                                                  'NEW $number',
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
  }
}