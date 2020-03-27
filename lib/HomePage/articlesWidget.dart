import 'dart:async';

import './fullArticlePage.dart';
import 'package:flutter/material.dart';

import 'ArticleCard.dart';

class ArticlesWidget extends StatelessWidget {
  final List<dynamic> articlesData;
  ArticlesWidget({this.articlesData});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Learn how to plant crops articles.',
            softWrap: true,
            style: TextStyle(
              color: Colors.blue, //Color.fromRGBO(10, 17, 40, 1.0),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          margin: EdgeInsets.only(bottom: AppBar().preferredSize.height + 80,),
          child: Column(
            children: articlesData.map((articleData) {
              return Column(
                children: <Widget>[
                  ArticleCard(
                    leadingImage: articleData['cover_image'],
                    title: articleData['crop'],
                    subTitle: articleData['description'],
                    onTap: () => Navigator.of(context).pushNamed(
                      FullArticlePage.nameRoute,
                      arguments: [
                        articleData['article_id'],
                        articleData['crop'],
                        articleData['description'],
                      ],
                    ),
                    articleId: articleData['article_id'],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ArticlesSkeletonWidget extends StatefulWidget {
  @override
  _ArticlesSkeletonWidgetState createState() => _ArticlesSkeletonWidgetState();
}

class _ArticlesSkeletonWidgetState extends State<ArticlesSkeletonWidget> {

  @override
  void initState() {
    // TODO: implement initState
    startAnimation();
    super.initState();
  }

  bool _animateOpacity = true , val = true;

  startAnimation(){
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      if(mounted){
        setState(() {
          _animateOpacity = !_animateOpacity;
        });
        
      }else{
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List temp = List(5);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Learn how to plant crops with our articles.',
            softWrap: true,
            style: TextStyle(
              color: Colors.blue, //Color.fromRGBO(10, 17, 40, 1.0),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Column(
          children: temp.map((articleData) {
            return Column(
              children: <Widget>[
                Container(
                  height: 125,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color.fromRGBO(163, 155, 168, 1.0),
                      style: BorderStyle.solid,
                      width: 0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: <Widget>[
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: _animateOpacity ? (val ? 0.2 : 0.6) : (val ? 0.6 : 0.2),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  height: 15,
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(right: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.navigate_next,
                                                  size: 20,
                                                  color:
                                                      Color.fromRGBO(10, 17, 40, 1.0),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              Container(
                                                height: 15,
                                                width: double.infinity,
                                                margin: EdgeInsets.only(right: 30.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              Container(
                                                height: 15,
                                                width: double.infinity,
                                                margin: EdgeInsets.only(right: 100.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
