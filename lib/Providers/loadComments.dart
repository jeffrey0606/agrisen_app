import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadComments extends ChangeNotifier {
  List<dynamic> _comments = [];

  List<dynamic> get getComments {
    return [..._comments];
  }

  Future<void> fechComments() async {
    try {
      var url = '';
      if (_comments.isNotEmpty) {
        url =
            'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchComments.php?comment_timestamp=${_comments[0]['comment_timestamp']}';
      } else {
        url =
            'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchComments.php';
      }
      if (url.isNotEmpty) {
        final response = await http.get(url);

        if (response != null) {
          final result = json.decode(response.body);

          if (result['status'] == 200) {
            print('all ${result['status']}');
            _comments = result['comments'];
          } else if (result['status'] == 201) {
            print('update ${result['status']}');
            List<dynamic> comments = result['comments'];
            for(int i = 0; i < comments.length; i++){
              _comments.insert(i, comments[i]);
            }
          }
        }
      }

      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }
  }

  void emptyComments() {
    _comments = [];

    notifyListeners();
  }

  List<dynamic> getParentComnents(String askHelpId) {
    return _comments
        .where((test) =>
            test['parent_comment_id'] == null &&
            test['askHelp_id'] == askHelpId)
        .toList();
  }

  int getCommentsNumber(String askHelpId) {
    final comments = _comments.where((test) => test['askHelp_id'] == askHelpId);

    return comments.length;
  }

  List<dynamic> getChildrenComments(String parentCommentId, String askHelpId) {
    return _comments
        .where((test) =>
            test['parent_comment_id'] == parentCommentId &&
            test['askHelp_id'] == askHelpId)
        .toList();
  }

  List<dynamic> getComentors(String apiKey, String askHelpId) {
    final temp = [];

    for (int i = 0; i < _comments.length; i++) {
      if (temp.any(
          (test) => test['commentor_id'] == _comments[i]['commentor_id'])) {
        continue;
      } else if (apiKey == _comments[i]['api_key']) {
        continue;
      } else if (_comments[i]['askHelp_id'] == askHelpId) {
        temp.add(_comments[i]);
      }
    }

    return temp;
  }
}
