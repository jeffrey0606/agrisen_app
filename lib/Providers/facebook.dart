import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class Facebook {

  static final facebookLogin = FacebookLogin();

  static Future<dynamic> signin() async{
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,first_name,last_name,email&access_token=${token}');
        final profile = json.decode(graphResponse.body);
          
        return profile;
      case FacebookLoginStatus.cancelledByUser:
        return false;
      case FacebookLoginStatus.error:
        return false;
    }
  }

  static Future<void> signout() async{
    try {
      await facebookLogin.logOut();
    } catch (e) {
      throw 'couldn\'t logout please check your internet';
    }
  }
}