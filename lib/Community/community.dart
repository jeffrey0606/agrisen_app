import 'dart:async';
import 'dart:convert';

import 'package:agrisen_app/Providers/loadNotification.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AskCommunity/QuestionsAsked.dart';
import 'Commented/commented.dart';
import 'package:http/http.dart' as http;

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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (once) {
      await Provider.of<LoadNotifications>(context, listen: false).fetchNotificationDetails();
      final userProvider = Provider.of<UserInfos>(context, listen: false);
      if (userProvider.userInfos['user_id'] == null) {
        await userProvider.getUser();
        await notYetViewComments();
      }
    }
    once = false;
  }

  bool isThereNotYetViewComments = false, start = true;

  setAlreadyView() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        isThereNotYetViewComments = false;
      });
    });
  }

  Future<void> notYetViewComments() async {
    final url =
        'http://192.168.43.150/agrisen-api/index.php/Community/not_yet_view_comments';
    final userProvider = Provider.of<UserInfos>(context, listen: false);
    await http.get(url,
        headers: {'api_key': userProvider.userInfos['api_key']}).then((_) {
      final result = _.body.toString().isEmpty ? false : json.decode(_.body);
      if (result) {
        setState(() {
          isThereNotYetViewComments = true;
        });
        print('object');
      }
    }).catchError((onError) {
      print('onError: $onError');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    fontFamily: 'MontserratAlternates',
                  ),
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black45,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: 'MontserratAlternates',
                  ),
                  tabs: <Widget>[
                    Tab(
                      text: 'Questions Asked',
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Commented'),
                          SizedBox(
                            width: isThereNotYetViewComments ? 15 : 0,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            alignment: Alignment.centerRight,
                            constraints: BoxConstraints(
                              maxHeight: isThereNotYetViewComments ? 12 : 0,
                              maxWidth: isThereNotYetViewComments ? 12 : 0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  offset: Offset(1, 2),
                                ),
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  blurRadius: 1,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          )
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
              QuestionsAsked(
                notYetViewComments: notYetViewComments,
              ),
              Commented(
                setAlreadyView: setAlreadyView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
