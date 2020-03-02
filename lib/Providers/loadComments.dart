import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoadComments extends ChangeNotifier{

  List<dynamic> _comments = [];

  List<dynamic> get getComments {
    return [..._comments];
  }

  Future<void> fechComments() async{
    try {
      final url =
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/fetchComments.php';
      final response = await http.get(url);

      if (response != null) {
        final result = json.decode(response.body);
        
        if ((result['status']) == 200) {
          _comments = result['comments'];
        }
      }

      notifyListeners();
    } catch (err) {
      print('err : $err');
      throw err;
    }
  }

  void emptyComments(){
    _comments = [];
    
    notifyListeners();
  }

  List<dynamic> getParentComnents(String askHelpId) {
    return _comments.where((test) => test['parent_comment_id'] == null && test['askHelp_id'] == askHelpId).toList();
  }

  int getCommentsNumber(String askHelpId){
    final comments = _comments.where((test) => test['askHelp_id'] == askHelpId);

    return comments.length;
  }

  List<dynamic> getChildrenComments(String parentCommentId, String askHelpId) {
    return _comments.where((test) => test['parent_comment_id'] == parentCommentId && test['askHelp_id'] == askHelpId).toList();
  }

  List<dynamic> getComentors(String apiKey){
    final temp = [];

    for(int i = 0; i < _comments.length; i++){

      if(temp.any((test) => test['commentor_id'] == _comments[i]['commentor_id'])){
        continue;
      }else if(apiKey == _comments[i]['api_key']){
        continue;
      }else{
        temp.add(_comments[i]);
      }
    }

    return temp;
  }
}