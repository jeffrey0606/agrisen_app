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
      final last_timestamp = _helpsData.isNotEmpty
          ? '?last_timestamp=${_helpsData[0]['timestamp']}'
          : '';
      final url =
          'http://192.168.43.150/agrisen-api/index.php/Community/fetch_helps$last_timestamp';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body) as List<dynamic>;

        if (result != null) {
          if (last_timestamp == '') {
            if (result.isNotEmpty) {
              print('result: $result');
              _helpsData = result;
            } else {
              print('object');
              _helpsData = ['a'];
            }
            notifyListeners();
          } else {
            print('result1: $result');
            for (int i = 0; i < result.length; i++) {
              _helpsData.insert(i, result[i]);
            }
            notifyListeners();
          }
        }
      }
    } catch (err) {
      throw err;
    }
  }

  dynamic getHelp(String helpId) {
    return _helpsData.firstWhere((test) => test['askHelp_id'] == helpId);
  }

  List<dynamic> getAllYourAskHelps(String userId) {
    return _helpsData.where((test) => test['user_id'] == userId).toList();
  }
}
