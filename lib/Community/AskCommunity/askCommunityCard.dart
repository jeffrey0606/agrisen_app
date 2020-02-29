import 'dart:io';

import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AskCommunityCard extends StatefulWidget {
  final String cropName;
  final String question;
  final String userName;
  final String profileImage;
  final String timelapse;
  final Function onTap;
  final String cropImage;
  final String askHelpId;

  AskCommunityCard({
    this.onTap,
    this.cropName,
    this.question,
    this.userName,
    this.profileImage,
    this.timelapse,
    this.cropImage,
    this.askHelpId,
  });

  @override
  _AskCommunityCardState createState() => _AskCommunityCardState();
}

class _AskCommunityCardState extends State<AskCommunityCard> {
  bool once = true;
  String commentsNumber = '0';

  @override
  void didChangeDependencies() async {
    if (once) {
      await Provider.of<LoadComments>(context, listen: false)
          .fechComments(widget.askHelpId);

      final temp = Provider.of<LoadComments>(context, listen: false)
          .getCommentsNumber(widget.askHelpId)
          .toString();

      setState(() {
        commentsNumber = temp;
      });
    }
    once = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 0, right: 0, bottom: 5),
      child: Card(
        child: InkWell(
          onTap: () => widget.onTap(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 340,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.network(
                      'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${this.widget.cropImage}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Colors.blue,
                                backgroundImage:
                                    NetworkImage(widget.profileImage),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    this.widget.userName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    this.widget.timelapse,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            this.widget.question.endsWith('?')
                                ? this.widget.question
                                : '${this.widget.question} ?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  this.widget.cropName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
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
                                            commentsNumber,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Comments',
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
