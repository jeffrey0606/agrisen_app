import 'dart:async';
import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:agrisen_app/Providers/loadNotification.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/imagesViewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/notifications.dart';
import 'MainAppContainer.dart';
import './HomePage/fullArticlePage.dart';
import './Community/CommentingPage/commentingPage.dart';
import './Community/AskCommunity/askCommunityForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSpashScreen = true;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showSpashScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserInfos()),
        ChangeNotifierProvider.value(value: LoadHelps()),
        ChangeNotifierProvider.value(value: LoadComments()),
        ChangeNotifierProvider.value(value: LoadCommentedHelps()),
        ChangeNotifierProvider.value(value: LoadNotifications()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'MontserratAlternates',
          accentColor: Color.fromRGBO(237, 245, 252, 1.0),
          //primaryColor: Color.fromRGBO(237, 245, 252, 1.0),
          appBarTheme: AppBarTheme(
            color: Color.fromRGBO(237, 245, 252, 1.0),
            actionsIconTheme: IconThemeData(
              color: Color.fromRGBO(10, 17, 40, 1.0),
            ),
            textTheme: TextTheme(
              title: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 22,
                fontFamily: 'MontserratAlternates',
                //fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        home: _showSpashScreen ? SplashScreenWidget() : MainAppContainer(),
        routes: {
          FullArticlePage.nameRoute: (ctx) => FullArticlePage(),
          DiseaseDetectionPage.nameRoute: (ctx) => DiseaseDetectionPage(),
          Notifications.nameRoute: (ctx) => Notifications(),
          CommentingPage.routeName: (ctx) => CommentingPage(),
          AskCommunityForm.routeName: (ctx) => AskCommunityForm(),
          ImagesViewer.namedRoute: (ctx) => ImagesViewer(),
        },
      ),
    );
  }
}

class SplashScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Center(
        child: Image.asset(
          'assets/agrisen_logo_trans.png',
        ),
      ),
    );
  }
}
