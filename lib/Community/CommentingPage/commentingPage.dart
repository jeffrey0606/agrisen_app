import 'dart:async';
import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/loadHelps.dart';
import '../../imagesViewer.dart';
import 'aCommentCard.dart';
import 'package:http/http.dart' as http;

class CommentingPage extends StatefulWidget {
  static const routeName = 'CommentingPage';

  @override
  _CommentingPageState createState() => _CommentingPageState();
}

class _CommentingPageState extends State<CommentingPage> {
  bool _isReplying = false, once = true;
  bool tagging = false, _isLoggin = false;
  String api_key = '';

  final _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    fetchComments();

    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      if (visible) {
        FocusScope.of(context).requestFocus(_commentFocusNode);
      } else {
        _commentFocusNode.unfocus();
      }
    });
  }

  fetchComments() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (mounted && askHelpId != '') {
        await Provider.of<LoadComments>(context, listen: false)
            .fechComments(askHelpId);
      } else {
        timer.cancel();
      }
    });
  }

  var tagName = '';
  List<String> tags = [];
  String _parentCommentId = null;
  var user_id = '';
  var _hasCommented = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      final userInfos =
          Provider.of<UserInfos>(context, listen: false).userInfos;
      setState(() {
        api_key = userInfos['api_key'];
        user_id = userInfos['user_id'];
        askHelpId = ModalRoute.of(context).settings.arguments as String;
        ;
        once = false;
      });
      if (userInfos['user_id'] != null && askHelpId != '') {
        await http
            .get(
                'http://192.168.43.150/agrisen-api/index.php/Community/has_commented?askHelp_id=${int.parse(askHelpId)}&user_id=${int.parse(user_id)}')
            .then((_) {
              print('has commented: ${json.decode(_.body)}');
          setState(() {
            _hasCommented = json.decode(_.body);
          });
        });
      }
    }
  }

  snakebar(String message) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  bool _showMore = false, _isAReplyOpen = false;

  int _currentIndex = 0;

  String askHelpId = '';

  final commentText = TextEditingController();

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
  void dispose() async {
    super.dispose();
    if (_hasCommented) {
      final _url =
          'http://192.168.43.150/agrisen-api/index.php/Community/insert_or_update_commented_helps';
      await http.post(_url, body: {
        'askHelp_id': askHelpId,
      }, headers: {
        'api_key': api_key
      }).then((_) {
        tags = [];
      }).catchError((onError) {
        print('object: $onError');
      });
    }
    _commentFocusNode.dispose();
    commentText.dispose();
  }

  Future<void> sendComment(
      String askHelpId,
      List<String> tags,
      String parentCommentId,
      String cropName,
      String images,
      String question) async {
    try {
      final url =
          'http://192.168.43.150/agrisen-api/index.php/Community/comment';

      final tag = tags.isNotEmpty ? json.encode(tags) : json.encode(null);

      final response = await http.post(url, body: {
        'askHelp_id': askHelpId,
        'parent_comment_id': json.encode(parentCommentId),
        'comment': commentText.text,
        'tags': tag
      }, headers: {
        'api_key': api_key
      });

      if (response != null) {
        final result = response.body.toString().isEmpty
            ? false
            : json.decode(response.body);

        if (result) {
          final _url =
              'http://192.168.43.150/agrisen-api/index.php/Community/insert_or_update_commented_helps';
          await http.post(_url, body: {
            'askHelp_id': askHelpId,
          }, headers: {
            'api_key': api_key
          }).then((_) async {
            setState(() {
              _parentCommentId = '';
              commentText.text = '';
              _isReplying = false;
              tags = [];
            });
            await Provider.of<LoadComments>(context, listen: false)
                .fechComments(askHelpId);
          }).catchError((err) {
            setState(() {
              _parentCommentId = '';
              _isReplying = false;
              tags = [];
            });
            print('erru: $err');
          });
        } else {
          setState(() {
            _parentCommentId = '';
            _isReplying = false;
            tags = [];
          });
          print('failed to send message try again');
        }
      }
    } catch (e) {
      setState(() {
        _parentCommentId = '';
        _isReplying = false;
      });
      tags = [];
      print('errs: $e');
    }
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final comment = Provider.of<LoadComments>(context);

    final parentComments = comment.getParentComnents(askHelpId);
    final help = Provider.of<LoadHelps>(context).getHelp(askHelpId);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final commentors = comment.getComentors(user_id, askHelpId);
    final images = json.decode(help['crop_images']);

    return Scaffold(
      key: _globalKey,
      body: Scrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.black.withOpacity(0.1),
              expandedHeight: MediaQuery.of(context).size.height * .3,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  if (_hasCommented) {
                    final _url =
                        'http://192.168.43.150/agrisen-api/index.php/Community/insert_or_update_commented_helps';
                    await http.post(_url, body: {
                      'askHelp_id': askHelpId,
                    }, headers: {
                      'api_key': api_key
                    }).then((_) {
                      tags = [];
                      Navigator.of(context).pop();
                    }).catchError((_) {
                      print('object1: $_');
                      Navigator.of(context).pop();
                    });
                  } else {
                    print('has not commented');
                    tags = [];
                    Navigator.of(context).pop();
                  }
                },
              ),
              elevation: 3,
              pinned: true,
              title: Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.view_carousel,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(
                    ImagesViewer.namedRoute,
                    arguments: {
                      'from': 'network',
                      'images': images,
                    },
                  ),
                )
              ],
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              titleSpacing: 0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.symmetric(
                  horizontal: 60.0,
                ),
                background: Image.network(
                  'http://192.168.43.150/agrisen-api/uploads/ask_helps/${images[0]}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                collapseMode: CollapseMode.parallax,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    help['question'].endsWith('?')
                        ? help['question']
                        : '${help['question']} ?',
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
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                top: 5.0,
                bottom: 70.0,
                right: 5.0,
                left: 5.0,
              ),
              sliver: parentComments.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No comment available yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (builder, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              children: <Widget>[
                                Dismissible(
                                  key: UniqueKey(),
                                  confirmDismiss: (_) async {
                                    FocusScope.of(context)
                                        .requestFocus(_commentFocusNode);
                                    setState(() {
                                      _parentCommentId =
                                          parentComments[index]['comment_id'];
                                      _isReplying = !_isReplying;
                                    });
                                    print(_parentCommentId);
                                    return false;
                                  },
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (_) {},
                                  child: ACommentCard(
                                    parentProfileImage: parentComments[index]
                                                ['profile_image']
                                            .toString()
                                            .startsWith('https://')
                                        ? parentComments[index]['profile_image']
                                        : 'http://192.168.43.150/agrisen-api/uploads/profile_images/${parentComments[index]['profile_image']}',
                                    parentComment: parentComments[index]
                                        ['comment'],
                                    commentorName: parentComments[index]
                                        ['user_name'],
                                    timelapse: TimeAjuster.ajust(DateTime.parse(
                                        parentComments[index]
                                            ['comment_timestamp'])),
                                    childComments: comment.getChildrenComments(
                                        parentComments[index]['comment_id'],
                                        askHelpId),
                                    currentIndex: _currentIndex,
                                    index: index,
                                    viewReplies: _showMore,
                                    viewRepliesFunction: () =>
                                        _viewReplies(index),
                                  ),
                                  background: Container(
                                    color: Colors.black12,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                if (index == parentComments.length)
                                  SizedBox(
                                    height: keyboardHeight + 100,
                                  )
                              ],
                            ),
                          );
                        },
                        childCount: parentComments.length,
                      ),
                    ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      if (tagging)
                        Container(
                          height: commentors.length > 4 ? 150 : null,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(237, 245, 252, 1.0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: commentors.map((comment) {
                                final index = commentors.indexOf(comment);
                                return Column(
                                  children: <Widget>[
                                    if (index != 0)
                                      Divider(
                                        indent:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                      ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        maxRadius: 15,
                                        backgroundImage: NetworkImage(
                                          comment['profile_image']
                                                  .toString()
                                                  .startsWith('https://')
                                              ? comment['profile_image']
                                              : 'http://192.168.43.150/agrisen-api/uploads/profile_images/${comment['profile_image']}',
                                        ),
                                      ),
                                      title: Text(comment['user_name']),
                                      onTap: () {
                                        setState(() {
                                          tagging = false;
                                          tagName = comment['user_name'];
                                          commentText.text =
                                              commentText.text + tagName + ' ';
                                          commentText.selection =
                                              TextSelection.fromPosition(
                                            TextPosition(
                                              offset: commentText.text.length,
                                            ),
                                          );

                                          if (tagName.isNotEmpty) {
                                            tags.add(comment['commentor_id']);
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      if (_isReplying)
                        Dismissible(
                          direction: DismissDirection.horizontal,
                          key: UniqueKey(),
                          confirmDismiss: (_) async {
                            return true;
                          },
                          onDismissed: (_) {
                            _parentCommentId = null;
                            _isReplying = false;
                            print(_parentCommentId);
                          },
                          child: ClipRRect(
                            borderRadius: tagging
                                ? BorderRadius.zero
                                : BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: tagging
                                  ? BoxDecoration()
                                  : BoxDecoration(
                                      color: Color.fromRGBO(237, 245, 252, 1.0),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                    ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    bottom: 5,
                                    left: 5,
                                    child: Text(
                                      'Replying...',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 5,
                                    bottom: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _parentCommentId = null;
                                          _isReplying = false;
                                        });
                                        print(_parentCommentId);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text('x'),
                                        maxRadius: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      Scrollbar(
                        child: TextField(
                          controller: commentText,
                          onChanged: (text) {
                            if (text.endsWith('@')) {
                              setState(() {
                                tagging = true;
                              });
                            } else {
                              setState(() {
                                tagName = '';
                                tagging = false;
                              });
                            }
                          },
                          focusNode: _commentFocusNode,
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            cut: true,
                            paste: true,
                            selectAll: true,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          minLines: 1,
                          maxLines: 7,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 18),
                            contentPadding: EdgeInsets.all(8.0),
                            border: InputBorder.none,
                            hintText: 'Comment...',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              FloatingActionButton(
                onPressed: api_key != null
                    ? () async {
                        if (commentText.text.isNotEmpty) {
                          await sendComment(
                            askHelpId,
                            tags,
                            _parentCommentId,
                            help['crop_name'],
                            help['crop_images'],
                            help['question'],
                          );
                        }
                      }
                    : null,
                elevation: 5,
                child: Icon(
                  Icons.send,
                  size: 35,
                ),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          SizedBox(
            height: keyboardHeight + 10,
          )
        ],
      ),
    );
  }
}
//Color.fromRGBO(237, 245, 252, 1.0),
