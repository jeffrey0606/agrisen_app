import 'package:agrisen_app/Providers/dummyData.dart';
import 'package:flutter/material.dart';

class FullArticlePage extends StatelessWidget {
  static const nameRoute = 'FullArticlePage';

  @override
  Widget build(BuildContext context) {
    final articleId = ModalRoute.of(context).settings.arguments as String;
    final articleData =
        DummyData().dummyData.firstWhere((test) => test.articleId == articleId);
    return Scaffold(
      appBar: AppBar(
        title: Text(articleData.title),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
      ),
      body: Container(
        height: 250,
        width: double.infinity,
        child: Hero(
          tag: articleId,
          child: FadeInImage(
            placeholder: AssetImage('assets/testImage1.png'),
            image: NetworkImage(
              articleData.leadingImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
