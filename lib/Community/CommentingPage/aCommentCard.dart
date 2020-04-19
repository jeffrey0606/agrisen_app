import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/material.dart';

class ACommentCard extends StatelessWidget {
  final String timelapse;
  final List<dynamic> childComments;
  final bool viewReplies;
  final int currentIndex;
  final int index;
  final Function viewRepliesFunction;
  final String parentComment;
  final String commentorName;
  final String parentProfileImage;

  ACommentCard({
    this.parentProfileImage,
    this.timelapse,
    this.childComments,
    this.viewReplies = false,
    this.currentIndex = 0,
    this.index = 0,
    this.viewRepliesFunction,
    this.parentComment,
    this.commentorName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(this.parentProfileImage),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: <InlineSpan>[
                      TextSpan(
                        text: commentorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '   $timelapse',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    parentComment,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (childComments.isEmpty)
                    SizedBox(
                      height: 25,
                    ),
                  if (childComments.isNotEmpty)
                    FlatButton.icon(
                      icon: viewReplies && currentIndex == index
                          ? Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.blue,
                            )
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                      label: Text(
                        'view replies',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () => viewRepliesFunction(),
                    )
                ],
              ),
            ),
          ],
        ),
        if (viewReplies && currentIndex == index)
          Container(
            padding: EdgeInsets.only(
              left: 30.0,
              bottom: 20.0,
            ),
            child: Column(
              children: childComments.map((comment) {
                final profileImage = comment['profile_image'];

                print(profileImage);

                var nameInitials = '';
                comment['user_name'].split(' ').forEach((f) {
                  if (nameInitials.length == 1) {
                    nameInitials += ' ';
                  }
                  nameInitials += '${f.substring(0, 1)}';
                });

                return Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        profileImage == null
                            ? Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        //Colors.lime,
                                        //Colors.pink,
                                        Colors.cyan,
                                        Colors.cyanAccent
                                      ]),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(60),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    nameInitials.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ))
                            : CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(profileImage
                                        .toString()
                                        .startsWith('https://')
                                    ? profileImage
                                    : 'http://192.168.43.150/agrisen-api/uploads/profile_images/$profileImage'),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: <InlineSpan>[
                                  TextSpan(
                                    text: comment['user_name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '   ${TimeAjuster.ajust(DateTime.parse(comment['comment_timestamp']))}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                comment['comment'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
