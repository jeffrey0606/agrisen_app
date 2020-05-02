import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoadNotifications extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> _viewedNotifications = [];

  List<Map<String, dynamic>> get notifications {
    return [..._notifications];
  }

  List<Map<String, dynamic>> get viewedNotifications {
    return [..._viewedNotifications];
  }

  int get newNotifications {
    int i = 0;
    _notifications.forEach((notif){
      if(!_viewedNotifications.any((test) => test['notification_id'] == notif['notification_id'])){
        i++;
      }
    });
    print('new: $i');
    return i;
  }

  Future<void> fetchNotificationDetails() async {
    final sharedPref = await SharedPreferences.getInstance();

    if (sharedPref.containsKey('userInfos')) {
      final userinfos = json.decode(sharedPref.getString('userInfos'));
        final response = await http.post('http://192.168.43.150/agrisen-api/index.php/Profile/fetch_notification_details', headers: {
          'api_key': userinfos['api-key'],
        }, body: {
          'time_viewed': _viewedNotifications.isNotEmpty ? _viewedNotifications[0]['time_viewed'] : '',
          'time_send': _notifications.isNotEmpty ? _notifications[0]['time_send'] : '',
        });

        final result1 = json.decode(response?.body);

        if (result1 != null) {
          final result = result1 as Map<String, dynamic>;
          if(result['notifications_details'].isNotEmpty){
            print('_notifications: ${result['notifications_details']}');
            for(int i = 0; i < result['notifications_details'].length; i++){
              _notifications.insert(i, result['notifications_details'][i]);
            }
          }
          if(result['viewed_notifications'].isNotEmpty){
            print('_viewedNotifications: ${result['viewed_notifications']}');
            for(int i = 0; i < result['viewed_notifications'].length; i++){
              _viewedNotifications.insert(i, result['viewed_notifications'][i]);
            }
          }

          //print('_notifications: $_notifications');
          //print('_viewedNotifications: $_viewedNotifications');

          notifyListeners();
        }
    }
  }
}
