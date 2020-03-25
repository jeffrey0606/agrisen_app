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
          'http://192.168.43.150/agrisen-api/index.php/Home/fetch_articles';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body);
        
        _articlesData = result;
        print(result);
      }
      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }
  }

  Future<dynamic> getArticle(String articleId) async{
    try {
      final url = 'http://192.168.43.150/agrisen-api/index.php/Home/fetch_articles/${int.parse(articleId)}';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body);
        
        _articlesData = result;
        print(result);
      }
      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }

    return _articlesData.firstWhere((test) => test['article_id'] == articleId);
  }
}
