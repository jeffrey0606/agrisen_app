import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoadHelps extends ChangeNotifier {
  List<dynamic> _helpsData = [];

  List<dynamic> get getHelpsData {
    return [..._helpsData];
  }

  Future<void> fetchHelps() async {
    try {
      final url =
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchHelps.php';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body);
        
        if ((result['status']) == 200) {
          _helpsData = result['helpsData'];
          //print('article : ${result['articlesData'][4]['article']}');

          /*final article = result['articlesData'][4]['article'].toString().split('\"');
          final coverImageLink = article.firstWhere((test) => test.trim().contains('http'));
          print('article $article');
          print('link: $coverImageLink');*/
        }
      }
    } catch (err) {
      print('err : $err');
      throw err;
    }
    notifyListeners();
  }

  dynamic getHelp(String helpId) {
    return _helpsData.firstWhere((test) => test['askHelp_id'] == helpId);
  }

  List<dynamic> getAllYourAskHelps(String apiKey){
    return _helpsData.where((test) => test['api_key'] == apiKey).toList();
  }
}
