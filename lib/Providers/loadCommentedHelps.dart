import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadCommentedHelps extends ChangeNotifier {
  List<dynamic> _commentedHelps = [];

  List<dynamic> get getCommentedHelps {
    return [..._commentedHelps];
  }

  Future<void> fechCommentedHelps(String apiKey) async {
    try {
      final url =
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchCommentedHelps.php';
      final response = await http.get(url, headers: {'api_key': apiKey});

      if (response != null) {
        final result = json.decode(response.body);

        if ((result['status']) == 200) {
          _commentedHelps = result['commentedHelps'];
        }
      }

      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }
  }

  List<dynamic> commentedHelps() {
    final temp = [];

    for (int i = 0; i < _commentedHelps.length; i++) {
      if (temp.any(
          (test) => test['askHelp_id'] == _commentedHelps[i]['askHelp_id'])) {
        continue;
      } else {
        temp.add(_commentedHelps[i]);
      }
    }

    return temp;
  }
}
