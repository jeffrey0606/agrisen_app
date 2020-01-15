import 'package:flutter/material.dart';

import 'hasLogin.dart';
import 'hasNotLogin.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isLogin = true;

    return Container(
      child: _isLogin ? HasLogin() : HasNotLogin(),
    );
  }
}
