import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoadArticles extends ChangeNotifier {
  List<dynamic> _articlesData = [];

  List<dynamic> get getArticlesData {
    return [..._articlesData];
  }

  Future<void> fetchArticles() async {
    try {
      final url =
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchArticles.php';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body);
        
        if ((result['status']) == 200) {
          _articlesData = result['articlesData'];
          //print('article : ${result['articlesData'][4]['article']}');

          /*final article = result['articlesData'][4]['article'].toString().split('\"');
          final coverImageLink = article.firstWhere((test) => test.trim().contains('http'));
          print('article $article');
          print('link: $coverImageLink');*/
        }
      }
      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }
  }

  dynamic getArticle(String articleId) {
    return _articlesData.firstWhere((test) => test['article_id'] == articleId);
  }
}
