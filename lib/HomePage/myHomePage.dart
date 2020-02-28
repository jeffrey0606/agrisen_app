import 'package:agrisen_app/Providers/loadArticles.dart';
import 'package:provider/provider.dart';
import '../widgets/Articles/ArticleCard.dart';
import '../widgets/Articles/fullArticlePage.dart';
import 'package:flutter/material.dart';

import 'homePageTopPart.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isScrolling = false, once = true;

  @override
  void didChangeDependencies() async{
    if(once){
      await Provider.of<LoadArticles>(context).fetchArticles();
    }
    once = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadArticles = Provider.of<LoadArticles>(context);
    final articlesData = loadArticles.getArticlesData;

    return Container(
      child:
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
        itemCount: articlesData.length,
        itemBuilder: ((context, index) {
          return Column(
            children: <Widget>[
              index == 0 ? HomePageTopPart() : Container(),
              SizedBox(
                height: 10.0,
              ),
              ArticleCard(
                leadingImage: articlesData[index]['cover_image'],
                title: articlesData[index]['crop_name'],
                subTitle: articlesData[index]['description'],
                onTap: () => Navigator.of(context).pushNamed(
                  FullArticlePage.nameRoute,
                  arguments: articlesData[index]['article_id'],
                ),
                articleId: articlesData[index]['article_id'],
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          );
        }),
      ),
    );
  }
}
