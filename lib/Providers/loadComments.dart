import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadComments extends ChangeNotifier {
  Map<String, List<dynamic>> _comments = {};

  Map<String, List<dynamic>> get getComments {
    return {..._comments};
  }

  Future<void> fechComments(String askHelpId) async {
    try {
      final last_timestamp = _comments.containsKey(askHelpId)
          ? '?last_timestamp=${json.encode(_comments[askHelpId][0]['comment_timestamp'])}'
          : '';
      final response = await http.get(
          'http://192.168.43.150/agrisen-api/index.php/Community/fetch_comments/$askHelpId/$last_timestamp');

      if (response != null) {
        final result = json.decode(response.body);

        if (result != null) {
          if (last_timestamp == '') {
            print('new $askHelpId: $result');
            if (result.isNotEmpty) {
              _comments.putIfAbsent(askHelpId, () => result);
            }
          } else {
            List<dynamic> comments = result;
            if (comments.isNotEmpty) {
              print('updated $askHelpId: $result');
              for (int i = 0; i < comments.length; i++) {
                _comments[askHelpId].insert(i, comments[i]);
              }
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
    _comments = {};

    notifyListeners();
  }

  List<dynamic> getParentComnents(String askHelpId) {
    if (_comments.containsKey(askHelpId)) {
      return _comments[askHelpId]
          .where((test) => test['parent_comment_id'] == null)
          .toList();
    }

    return [];
  }

  List<dynamic> getChildrenComments(String parentCommentId, String askHelpId) {
    if (_comments.containsKey(askHelpId)) {
      return _comments[askHelpId]
          .where((test) => test['parent_comment_id'] == parentCommentId)
          .toList();
    }

    return [];
  }

  List<dynamic> getComentors(String userId, String askHelpId) {
    final temp = [];

    if (_comments.containsKey(askHelpId)) {
      for (int i = 0; i < _comments[askHelpId].length; i++) {
        if (temp.any(
            (test) => test['user_id'] == _comments[askHelpId][i]['user_id'])) {
          continue;
        } else if (userId == _comments[askHelpId][i]['user_id']) {
          continue;
        } else {
          temp.add(_comments[askHelpId][i]);
        }
      }
    }
    return temp;
  }
}
