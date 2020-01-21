import 'package:flutter/material.dart';

class ACommentCard extends StatelessWidget {
  final String timelapse;
  final List<int> repliedComments;
  final bool viewReplies;
  final int currentIndex;
  final int index;
  final Function viewRepliesFunction;

  ACommentCard(
      {this.timelapse,
      this.repliedComments,
      this.viewReplies = false,
      this.currentIndex = 0,
      this.index = 0,
      this.viewRepliesFunction});

  @override
  Widget build(BuildContext context) {
    final string =
        'What\'s the problem with this my tomato leaves. It has black spots on it sdsd dscssd bddwiuw eds  wfwefw wedw ?';
    return AnimatedContainer(
      height: viewReplies && currentIndex == index
          ? repliedComments.length * 50.0
          : string.length * 1.2,
      duration: Duration(milliseconds: 600),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.blue,
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
                          text: 'Jeffrey Kengne',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '   $timelapse',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      string,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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
            Expanded(
              child: Column(
                children: repliedComments.map((nums) {
                  return Container(
                    child: Text('replied comment # $nums '),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }
}
