import 'dart:convert';

import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/material.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/loadHelps.dart';
import 'aCommentCard.dart';

class CommentingPage extends StatefulWidget {
  static const routeName = 'CommentingPage';

  @override
  _CommentingPageState createState() => _CommentingPageState();
}

class _CommentingPageState extends State<CommentingPage> {
  bool _isTextFieldTaped = false, _isReplying = false, once = true;
  bool tagging = false, _isLoggin = false;
  String api_key = '';

  final _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(onChange: (visible) {
      setState(() async {
        if (visible) {
          _isTextFieldTaped = true;
          FocusScope.of(context).requestFocus(_commentFocusNode);
        } else {
          final askHelpId = ModalRoute.of(context).settings.arguments as String;

          await Provider.of<LoadComments>(context, listen: false)
              .fechComments(askHelpId);
          _isTextFieldTaped = false;
          _commentFocusNode.unfocus();
        }
      });
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      final askHelpId = ModalRoute.of(context).settings.arguments as String;

      await Provider.of<LoadComments>(context).fechComments(askHelpId);

      final sharedPref = await SharedPreferences.getInstance();

      if(sharedPref.containsKey('userInfos')){
        final userinfos = json.decode(sharedPref.getString('userInfos'));
        setState(() {
          api_key = userinfos['api-key'];
          _isLoggin = true;
        });
      }else{
        snakebar('You haven\'t login to the app yet. you can do it at profile page!');
      }
    }
    once = false;
  }

  snakebar(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 15,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  bool _showMore = false, _isAReplyOpen = false;

  int _currentIndex = 0;

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
  void dispose() {
    super.dispose();
    _commentFocusNode.dispose();
    commentText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = Provider.of<LoadComments>(context);
    final parentComments = comment.getParentComnents();
    final askHelpId = ModalRoute.of(context).settings.arguments as String;
    final help = Provider.of<LoadHelps>(context).getHelp(askHelpId);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final commentors = comment.getComentors(api_key);

    print(commentors);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * .3,
            forceElevated: true,
            pinned: true,
            title: Text(
              'Comments',
              style: TextStyle(
                color: Colors.black,
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
              background: Image.network(
                'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${help['crop_image']}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              collapseMode: CollapseMode.parallax,
              title: Text(
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
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
              right: 5.0,
              left: 5.0,
            ),
            sliver: parentComments.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'No comment available yet',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
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
                                  parentProfileImage: parentComments[index]
                                              ['profile_image']
                                          .toString()
                                          .startsWith('https://')
                                      ? parentComments[index]['profile_image']
                                      : 'http://${parentComments[index]['profile_image']}',
                                  parentComment: parentComments[index]
                                      ['comment'],
                                  commentorName: parentComments[index]
                                      ['user_name'],
                                  timelapse: TimeAjuster.ajust(DateTime.parse(
                                      parentComments[index]['timestamp'])),
                                  childComments: comment.getChildrenComments(
                                      parentComments[index]['comment_id']),
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
                          ),
                        );
                      },
                      childCount: parentComments.length,
                    ),
                  ),
          )
        ],
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
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  //height: _isReplying ? 170 : 53,
                  child: Column(
                    children: <Widget>[
                      if (tagging)
                        Card(
                          elevation: 5,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 150,
                                margin: EdgeInsets.all(8.0),
                                padding: EdgeInsets.all(5.0),
                                color: Color.fromRGBO(237, 245, 252, 1.0),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => Divider(),
                                  itemCount: commentors.length,
                                  itemBuilder: (contex, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        maxRadius: 15,
                                        backgroundImage: NetworkImage(
                                          commentors[index]['profile_image']
                                                  .toString()
                                                  .startsWith('https://')
                                              ? commentors[index]
                                                  ['profile_image']
                                              : 'http://${commentors[index]['profile_image']}',
                                        ),
                                      ),
                                      title: Text(commentors[index]['user_name']),
                                      onTap: () => null,
                                    );
                                  },
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
                      SizedBox(
                        width: 5,
                      ),
                      Card(
                        elevation: 5,
                        child: Scrollbar(
                          child: TextField(
                            controller: commentText,
                            onChanged: (text) {
                              if(text.endsWith('@')){
                                setState(() {
                                  tagging = true;
                                  commentText.text = commentText.text + 'jeffrey';
                                  
                                });
                              }else{
                                setState(() {
                                  tagging = false;
                                });
                              }
                              /*if (text.startsWith(new RegExp(r'^@')) && text.startsWith(new RegExp(r'[\w]'))) {
                                setState(() {
                                  tagging = true;
                                  commentText.text = commentText.text + 'jeffrey';
                                });
                              } else {
                                setState(() {
                                  commentText.text = commentText.text;
                                  tagging = false;
                                });
                              }*/
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
                            maxLines: 5,
                            style: TextStyle(fontSize: 22),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 22),
                              contentPadding: EdgeInsets.all(8.0),
                              border: OutlineInputBorder(),
                              hintText: 'Comment...',
                            ),
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
                onPressed: _isLoggin ? () => null : null,
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
