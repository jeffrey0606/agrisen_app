import 'package:flutter/material.dart';

import 'AskCommunity/QuestionsAsked.dart';
import 'Commented/commented.dart';

class Community extends StatelessWidget {
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
                                  '13',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
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
