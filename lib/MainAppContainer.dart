import 'dart:convert';

import 'package:agrisen_app/Providers/facebook.dart';
import 'package:agrisen_app/Providers/google.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage/myHomePage.dart';
import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/hasNotLogin.dart';
import 'Community/community.dart';
import './Community/AskCommunity/askCommunityForm.dart';
import 'Providers/loadComments.dart';

class MainAppContainer extends StatefulWidget {
  @override
  _MainAppContainerState createState() => _MainAppContainerState();
}

enum MenuItems {
  settings,
  logout,
}

class _MainAppContainerState extends State<MainAppContainer> {
  int _currentTab = 0;
  bool once = true;
  final List<Widget> screens = [
    MyHomePage(),
    Community(),
    HasNotLogin(),
  ];

  @override
  void didChangeDependencies() async{
    if(once){
      await Provider.of<LoadHelps>(context).fetchHelps();
      await Provider.of<LoadComments>(context, listen: false).fechComments();
    }
    once = false;
    super.didChangeDependencies();
  }

  snackBar(GlobalKey<ScaffoldState> globalKey, String message) {
    globalKey.currentState.showSnackBar(
      SnackBar(
        content: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 15,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signout(GlobalKey<ScaffoldState> globalKey) async {
    final sharedPref = await SharedPreferences.getInstance();

    if (sharedPref.containsKey('userInfos') == false) {
      setState(() {
        _currentTab = 2;
      });
      snackBar(
          globalKey, 'You haven\'t login to the app yet. you can do it here!');
    } else {
      final userinfos = json.decode(sharedPref.getString('userInfos'));
      
      final subscriber = userinfos['subscriber'];
      if (subscriber == 'google') {
        await Google.signout().catchError((onError) {
          snackBar(globalKey, onError);
        }).then((_) async {
          final res = await sharedPref.clear();

          if (res) {
            setState(() {
              if (_currentTab == 2) {
                _currentTab = 0;
              } else {
                _currentTab = 2;
              }
            });
          }
        });
      } else if (subscriber == 'facebook') {
        await Facebook.signout().catchError((onError) {
          snackBar(globalKey, onError);
        }).then((_) async {
          final res = await sharedPref.clear();

          if (res) {
            setState(() {
              if (_currentTab == 2) {
                _currentTab = 0;
              } else {
                _currentTab = 2;
              }
            });
          }
        });
      } else if (subscriber == 'emailAndpassword') {}
    }
  }

  final _globalkey = GlobalKey<ScaffoldState>();

  Future<void> alert(GlobalKey<ScaffoldState> globalKey) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to sign out ?'),
          contentPadding: EdgeInsets.all(15.0),
          title: Text('sign out'),
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () async {
                Navigator.pop(context);
                await signout(globalKey);
              },
              child: Text('Yes'),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _globalkey.currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalkey,
      appBar: _currentTab == 1
          ? null
          : AppBar(
              title: Text('Agrisen'),
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Color.fromRGBO(10, 17, 40, 1.0),
              ),
              actions: <Widget>[
                PopupMenuButton<MenuItems>(
                  onSelected: (items) {
                    switch (items) {
                      case MenuItems.logout:
                        alert(_globalkey);
                        break;
                      case MenuItems.settings:
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<MenuItems>>[
                    const PopupMenuItem<MenuItems>(
                      value: MenuItems.settings,
                      child: ListTile(
                        title: Text('Settings'),
                        onTap: null,
                        leading: Icon(Icons.settings),
                      ),
                    ),
                    const PopupMenuItem<MenuItems>(
                        value: MenuItems.logout,
                        child: ListTile(
                          title: Text('Logout'),
                          onTap: null,
                          leading: Icon(Icons.exit_to_app),
                        )),
                  ],
                )
              ],
            ),
      body: screens.elementAt(_currentTab),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/home.svg',
              height: _currentTab == 0 ? 25 : 15,
              color: _currentTab == 0
                  ? Color.fromRGBO(10, 17, 40, 1.0)
                  : Colors.grey,
            ),
            title: Text('home'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/askcomunity.svg',
              height: _currentTab == 1 ? 30 : 25,
              color: _currentTab == 1
                  ? Color.fromRGBO(10, 17, 40, 1.0)
                  : Colors.grey,
            ),
            title: Text('community'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/profile.svg',
              height: _currentTab == 2 ? 30 : 20,
              color: _currentTab == 2
                  ? Color.fromRGBO(10, 17, 40, 1.0)
                  : Colors.grey,
            ),
            title: Text('profile'),
          ),
        ],
        backgroundColor: Color.fromRGBO(237, 245, 252, 1.0),
        elevation: 15,
        selectedItemColor: Color.fromRGBO(10, 17, 40, 1.0),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _currentTab == 1
          ? FloatingActionButton.extended(
              onPressed: () async{
                final sharedPref = await SharedPreferences.getInstance();
                if (sharedPref.containsKey('userInfos')) {
                  final userInfos = json.decode(sharedPref.getString('userInfos'));
                  Navigator.pushNamed(context, AskCommunityForm.routeName, arguments: userInfos);
                } else {
                  setState(() {
                    _currentTab = 2;
                  });
                  snackBar(_globalkey, 'You haven\'t login to the app yet. you can do it here!');
                }
              },
              label: Text(
                'Ask Help',
                style: TextStyle(
                  color: Color.fromRGBO(237, 245, 252, 1.0),
                ),
              ),
              icon: Icon(
                Icons.help_outline,
                color: Color.fromRGBO(237, 245, 252, 1.0),
              ),
              backgroundColor: Color.fromRGBO(10, 17, 40, 1.0),
            )
          : FloatingActionButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed(DiseaseDetectionPage.nameRoute),
              child: ImageIcon(
                AssetImage(
                  'assets/runTestIcon.png',
                ),
                color: Color.fromRGBO(237, 245, 252, 1.0),
                size: 40,
              ),
              elevation: 5,
              tooltip: 'check for plant disease',
              backgroundColor: Color.fromRGBO(10, 17, 40, 1.0),
            ),
    );
  }
}
