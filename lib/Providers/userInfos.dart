import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserInfos extends ChangeNotifier {
  Map<dynamic, dynamic> _userInfos = {
    'user_id': null,
    'user_name': null,
    'email': null,
    'profile_image': null,
    'api_key': null,
  };

  Map<dynamic, dynamic> get userInfos {
    return {..._userInfos};
  }

  Future<void> getUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.containsKey('userInfos')) {
      final userinfos = json.decode(sharedPref.getString('userInfos'));

      final apiKey = userinfos['api-key'];

      try {
        final url =
            'http://161.35.10.255/agrisen-api/index.php/Profile/get_user';
        final response = await http.get(url, headers: {'api_key': apiKey});

        if (response != null) {
          final temp = json.decode(response.body) as Map<dynamic, dynamic>;

          //final profileImage = temp['profile_image'];
          temp.update('profile_image', (tempProfile) {
            return tempProfile.toString().isEmpty
                ? ''
                : tempProfile.toString().startsWith('https://')
                    ? tempProfile
                    : 'http://161.35.10.255/agrisen-api/uploads/profile_images/$tempProfile';
          });
          temp.putIfAbsent('api_key', () => apiKey);

          _userInfos = temp;
          print('user: $_userInfos');
        }
      } catch (err) {
        print('errors: $err');
      }
    } else {
      _userInfos = {
        'user_id': null,
        'user_name': null,
        'email': null,
        'profile_image': null,
        'api_key': null,
      };
    }
  }
}
