import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String leadingImage;
  final Function onTap;
  final String articleId;

  ArticleCard({
    @required this.title,
    @required this.subTitle,
    @required this.leadingImage,
    @required this.articleId,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
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
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                  child: Hero(
                      tag: this.articleId,
                      child: CachedNetworkImage(
                        imageUrl: this.leadingImage,
                        errorWidget: (ctx, str, obj) {
                          return Image.asset(
                            'assets/imageNotFoundOrange.png',
                            fit: BoxFit.cover,
                          );
                        },
                        placeholder: (str, obj) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlue,
                              strokeWidth: 1,
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      )),
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
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              this.title,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(10, 17, 40, 1.0),
                              ),
                              maxLines: 2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.navigate_next,
                              size: 20,
                              color: Color.fromRGBO(10, 17, 40, 1.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        this.subTitle,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(163, 155, 168, 1.0),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
//text sub: Color.fromRGBO(163, 155, 168, 1.0)
//text and icon: Color.fromRGBO(10, 17, 40, 1.0)
