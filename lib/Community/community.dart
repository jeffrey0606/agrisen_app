import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AskCommunity/QuestionsAsked.dart';
import 'Commented/commented.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
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
    final notYetViewedComments =
        Provider.of<LoadCommentedHelps>(context).getNotYetViewedComments;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceElevated: true,
                floating: true,
                pinned: true,
                snap: true,
                title: Text('Community'),
                centerTitle: true,
                expandedHeight: AppBar().preferredSize.height * 1.8,
                bottom: TabBar(
                  indicatorColor: Colors.blue,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 60),
                  labelStyle: TextStyle(
                    fontSize: 16,
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black45,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                  ),
                  tabs: <Widget>[
                    Tab(
                      text: 'Questions Asked',
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('Commented'),
                          if(notYetViewedComments.isNotEmpty)
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                25,
                              ),
                            ),
                            elevation: 5,
                            child: SizedBox(
                              height: 11,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(3),
                                constraints: BoxConstraints(
                                  minWidth: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                    25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              QuestionsAsked(),
              Commented(),
            ],
          ),
        ),
      ),
    );
  }
}
