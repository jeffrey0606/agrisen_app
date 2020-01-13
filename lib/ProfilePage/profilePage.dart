import 'package:agrisen_app/widgets/Drawer/Drawer.dart';
import 'package:flutter/material.dart';

import 'hasLogin.dart';
import 'hasNotLogin.dart';

class ProfilePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    bool _isLogin = true;

    final appBar = AppBar(
        title: Text('Profile'),
        centerTitle: true,
      );

    return Scaffold(
      appBar: appBar,
      drawer: DrawerLayout(),
      backgroundColor: Colors.white,
      body: _isLogin ? HasLogin(appBar: appBar) : HasNotLogin(),
    );
  }
}