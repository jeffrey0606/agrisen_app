import 'package:agrisen_app/Providers/google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'HomePage/myHomePage.dart';
import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/profilePage.dart';
import 'Community/community.dart';
import './Community/AskCommunity/askCommunityForm.dart';

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
  final List<Widget> screens = [
    MyHomePage(),
    Community(),
    ProfilePage(),
  ];

  void signout(GlobalKey<ScaffoldState> globalKey) async {
    await Google.signout().catchError(
      (onError) {
        
        globalKey.currentState.showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 15,
                ),
                Text(onError),
              ],
            ),
          ),
        );
      },
    );
  }

  final _globalkey = GlobalKey<ScaffoldState>();

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
                        signout(_globalkey);
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
              onPressed: () =>
                  Navigator.of(context).pushNamed(AskCommunityForm.routeName),
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
