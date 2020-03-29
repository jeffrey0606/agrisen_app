import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AskCommunity/QuestionsAsked.dart';
import 'Commented/commented.dart';

class Community extends StatefulWidget {
  final Function alert;
  Community({@required this.alert});
  @override
  _CommunityState createState() => _CommunityState();
}

enum MenuItems {
  settings,
  logout,
}

class _CommunityState extends State<Community> {
  bool once = true;
  String apiKey = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      final userProvider = Provider.of<UserInfos>(context);
      if (userProvider.userInfos['user_id'] == null) {
        await userProvider.getUser();
      }
      //_fechCommentedHelps(userinfos['api-key']);
      /*setState(() {
          apiKey = userinfos['api-key'];
        });*/
    }
    once = false;
  }

  /*void _fechCommentedHelps(String apiKey) async {
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechCommentedHelps(apiKey);
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechNotYetViewedComments(apiKey);
  }*/

  @override
  Widget build(BuildContext context) {
    //final notYetViewedComments =
        //Provider.of<LoadCommentedHelps>(context).getNotYetViewedComments;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                actions: <Widget>[
                  PopupMenuButton<MenuItems>(
                    onSelected: (items) {
                      switch (items) {
                        case MenuItems.logout:
                          widget.alert();
                          break;
                        case MenuItems.settings:
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MenuItems>>[
                      const PopupMenuItem<MenuItems>(
                        value: MenuItems.settings,
                        child: ListTile(
                          title: Text('Settings'),
                          onTap: null,
                          leading: Icon(Icons.settings),
                        ),
                      ),
                      const PopupMenuItem<MenuItems>(
                        value: MenuItems.logout,
                        child: ListTile(
                          title: Text('Logout'),
                          onTap: null,
                          leading: Icon(Icons.exit_to_app),
                        ),
                      ),
                    ],
                  )
                ],
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
                          //if (notYetViewedComments.isNotEmpty)
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
