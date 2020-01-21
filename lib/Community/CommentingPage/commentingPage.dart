import 'package:flutter/material.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'aCommentCard.dart';

class CommentingPage extends StatefulWidget {
  static const routeName = 'CommentingPage';

  @override
  _CommentingPageState createState() => _CommentingPageState();
}

class _CommentingPageState extends State<CommentingPage> {
  bool _isTextFieldTaped = false, _isReplying = false;

  final _commentFocusNode = FocusNode();

  Duration fullTime =
      DateTime.now().add(Duration(hours: 12)).difference(DateTime.now());

  String timelapse = '';

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      setState(() {
        if (visible) {
          _isTextFieldTaped = true;
          FocusScope.of(context).requestFocus(_commentFocusNode);
        } else {
          _isTextFieldTaped = false;
          _commentFocusNode.unfocus();
        }
      });
    });

    setState(() {
      if (fullTime.inMinutes < 60) {
        timelapse = 'il y ${fullTime.inMinutes} mins';
      } else if (fullTime.inHours < 24) {
        timelapse = 'il y ${fullTime.inHours} hours';
      } else if (fullTime.inHours >= 24 && fullTime.inDays < 7) {
        timelapse = 'il y ${fullTime.inDays} jour';
      } else if (fullTime.inDays >= 7 && fullTime.inDays < 30) {
        timelapse = 'il y ${(fullTime.inDays / 7).floor()} semaine';
      } else if (fullTime.inDays >= 30) {
        timelapse = 'il y ${(fullTime.inDays / 30).floor()} mois';
      }
    });
  }

  List<int> repliedComments = [
    1,
    2,
    3,
    4,
    5,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      setState(() {
        //visible ? _isTextFieldTaped = true : _isTextFieldTaped = false;
      });
    });
  }

  bool _showMore = false, _isAReplyOpen = false;

  int _currentIndex = 0;

  void _viewReplies(int index) {
    setState(() {
      if (_currentIndex == index) {
        if (_showMore) {
          _showMore = false;
          _isAReplyOpen = false;
        } else {
          _showMore = true;
          _isAReplyOpen = true;
        }
        _currentIndex = index;
      } else {
        if (_isAReplyOpen) {
          _showMore = false;
          _showMore = true;
          _isAReplyOpen = false;
        } else {
          _showMore = true;
          _isAReplyOpen = true;
        }
        _currentIndex = index;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _commentFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .3,
            title: Text(
              'Comments',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            iconTheme: IconThemeData(
              color: Color.fromRGBO(10, 17, 40, 1.0),
            ),
            titleSpacing: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.symmetric(
                horizontal: 60.0,
              ),
              background: Image.asset(
                'assets/backiee-117476-landscape.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              title: Text(
                'What\'s the problem with this my tomato leaves. It has black spots on it?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              right: 5.0,
              left: 5.0,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (builder, index) {
                  return Column(
                    children: <Widget>[
                      Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          FocusScope.of(context)
                              .requestFocus(_commentFocusNode);
                          setState(() {
                            _isReplying = !_isReplying;
                          });
                          return false;
                        },
                        child: ACommentCard(
                          timelapse: timelapse,
                          repliedComments: repliedComments,
                          currentIndex: _currentIndex,
                          index: index,
                          viewReplies: _showMore,
                          viewRepliesFunction: () => _viewReplies(index),
                        ),
                        background: Container(
                          color: Colors.black12,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.replay,
                              ),
                              Text(
                                'Reply',
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index == 9)
                        SizedBox(
                          height: 60,
                        )
                    ],
                  );
                },
                childCount: 10,
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.only(
          top: 0.0,
          bottom: _isTextFieldTaped ? 200.0 : 0.0,
          left: 0,
          right: 5.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Card(
                elevation: 5,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  height: _isReplying ? 170 : 53,
                  child: Column(
                    children: <Widget>[
                      if (_isReplying)
                        Expanded(
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(5.0),
                                  color: Color.fromRGBO(237, 245, 252, 1.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Jeffrey Kengne',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'What\'s the problem with this my tomato leaves. It has black spots on it?',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 3,
                                  right: 5,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isReplying = false;
                                      });
                                    },
                                    child: Container(
                                      width: 18,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Colors.blue,
                                            Colors.red
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        'x',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      TextField(
                        focusNode: _commentFocusNode,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        minLines: 2,
                        maxLines: 4,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(),
                          hintText: 'Comment...',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: FloatingActionButton(
                onPressed: () => null,
                elevation: 5,
                child: Icon(
                  Icons.send,
                  size: 35,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Color.fromRGBO(237, 245, 252, 1.0),
