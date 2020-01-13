import 'package:agrisen_app/Providers/dummyData.dart';
import 'package:agrisen_app/widgets/ArticleCard/ArticleCard.dart';
import 'package:agrisen_app/widgets/Drawer/Drawer.dart';
import 'package:agrisen_app/widgets/FullArticlePage/fullArticlePage.dart';
import 'package:flutter/material.dart';

import 'homePageTopPart.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isScrolling = false;
  @override
  Widget build(BuildContext context) {
    final dummyData = DummyData().dummyData;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agrisensor'),
      ),
      backgroundColor: Colors.white,
      body:
          /*NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            setState(() {
              _isScrolling = true;
            });
          } else if (scrollNotification is ScrollEndNotification) {
            setState(() {
              _isScrolling = false;
            });
          }
        },
        child: */
          ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: ((context, index) {
          return Column(
            children: <Widget>[
              index == 0 ? HomePageTopPart() : Container(),
              SizedBox(
                height: 10.0,
              ),
              ArticleCard(
                leadingImage: dummyData[index].leadingImage,
                title: dummyData[index].title,
                subTitle: dummyData[index].subTitle,
                onTap: () => Navigator.of(context).pushNamed(
                  FullArticlePage.nameRoute,
                  arguments: dummyData[index].articleId,
                ),
                articleId: dummyData[index].articleId,
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          );
        }),
      ),
      drawer: DrawerLayout(),
    );
  }
}
