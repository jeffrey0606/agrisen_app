import 'dart:convert';

import 'package:agrisen_app/Providers/loadNotification.dart';
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
    'verification': null,
  };

  Map<dynamic, dynamic> get userInfos {
    return {..._userInfos};
  }

  void updateProfileImage(String profileImage) {
    _userInfos.update('profile_image', (_) => profileImage);
    notifyListeners();
  }

  Future<void> getUser() async {
    final sharedPref = await SharedPreferences.getInstance();

    if (sharedPref.containsKey('userInfos')) {
      final userinfos = json.decode(sharedPref.getString('userInfos'));

      final apiKey = userinfos['api-key'];
      final subscriber = userinfos['subscriber'];

      print(apiKey);

      try {
        final url =
            'http://192.168.43.150/agrisen-api/index.php/Profile/get_user';
        final response = await http.get(url, headers: {'api_key': apiKey});

        if (response != null) {
          final temp = json.decode(response.body) as Map<dynamic, dynamic>;
          print('subscriber: $subscriber');
          if (subscriber == 'emailAndPassword') {
            if (temp['verified'] == 'yes') {
              if (sharedPref.containsKey('varification')) {
                sharedPref.remove('verification');
                temp.putIfAbsent('verification', () => null);
              }
            } else {
              final datetime = sharedPref.getString('verification');
              if (DateTime.parse(datetime)
                      .add(Duration(days: 3))
                      .compareTo(DateTime.now()) <
                  0) {
                await http.post('http://192.168.43.150/agrisen-api/index.php/Profile/delete_user', body: {
                  'email': temp['email'],
                  'password': temp['password']
                });
                await sharedPref.clear();
                _userInfos = {
                  'user_id': null,
                  'user_name': null,
                  'email': null,
                  'profile_image': null,
                  'api_key': null,
                  'verification': null,
                };
                notifyListeners();
                return;
              } else {
                temp.putIfAbsent('verification', () => datetime);
                print('verification:${_userInfos['verification']}');
                temp.remove('verified');
              }
            }
          } else {
            temp.remove('verified');
          }

          if (temp != null) {
            //final profileImage = temp['profile_image'];
            temp.remove('password');
            temp.update('profile_image', (tempProfile) {
              return tempProfile == null
                  ? ''
                  : tempProfile.toString().startsWith('https://')
                      ? tempProfile
                      : 'http://192.168.43.150/agrisen-api/uploads/profile_images/$tempProfile';
            });
            temp.putIfAbsent('api_key', () => apiKey);

            _userInfos = temp;
            print('user: $_userInfos');
          }
        }
        notifyListeners();
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
        'verification': null,
      };
    }
  }
}
