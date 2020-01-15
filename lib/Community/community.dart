import 'package:agrisen_app/Community/AskCommunity/askCommunity.dart';
import 'package:agrisen_app/Community/AskCommunity/commented.dart';
import 'package:flutter/material.dart';

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: AppBar().preferredSize.height * 1.7),
            child: TabBarView(
              children: <Widget>[
                AskCommunity(),
                Commented(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: AppBar().preferredSize.height * 2.3,
              child: AppBar(
                title: Text('Community'),
                centerTitle: true,
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
                      text: 'Commented',
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
