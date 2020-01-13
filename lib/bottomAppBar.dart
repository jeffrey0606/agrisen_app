import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'HomePage/myHomePage.dart';
import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/profilePage.dart';
class CustomBottomAppBar extends StatefulWidget {
  @override
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<CustomBottomAppBar> {
  int _currentTab = 0;
  final List<Widget> screens = [
    MyHomePage(),
    ProfilePage(),
  ];

  Widget _currentScreen = MyHomePage();

  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: _currentScreen,
        bucket: _bucket,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentScreen = MyHomePage();
            _currentTab = 0;
          });
          if(_currentTab == 0){
            Navigator.of(context).pushNamed(DiseaseDetectionPage.nameRoute);
          }
          },
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
      bottomNavigationBar: BottomAppBar(
        elevation: 15,
        notchMargin: 15,
        color: Color.fromRGBO(237, 245, 252, 1.0),
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.only(right: 20, top: 3, bottom: 3),
                minWidth: MediaQuery.of(context).size.width * .5,
                onPressed: () {
                  setState(() {
                    _currentScreen = MyHomePage();
                    _currentTab = 0;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/SVGPics/home.svg',
                      fit: BoxFit.cover,
                      height: _currentTab == 0 ? 30 : 20,
                      color: _currentTab == 0
                          ? Color.fromRGBO(10, 17, 40, 1.0)
                          : Color.fromRGBO(163, 155, 168, 1.0),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: _currentTab == 0
                            ? Color.fromRGBO(10, 17, 40, 1.0)
                            : Color.fromRGBO(163, 155, 168, 1.0),
                        fontSize: _currentTab == 0 ? 14 : 12,
                      ),
                    )
                  ],
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.only(left: 20, top: 3, bottom: 3),
                onPressed: () {
                  setState(() {
                    _currentScreen = ProfilePage();
                    _currentTab = 1;
                  });
                },
                minWidth: MediaQuery.of(context).size.width * .5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/SVGPics/profile.svg',
                      fit: BoxFit.cover,
                      height: _currentTab == 1 ? 30 : 20,
                      color: _currentTab == 1
                          ? Color.fromRGBO(10, 17, 40, 1.0)
                          : Color.fromRGBO(163, 155, 168, 1.0),
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: _currentTab == 1
                            ? Color.fromRGBO(10, 17, 40, 1.0)
                            : Color.fromRGBO(163, 155, 168, 1.0),
                        fontSize: _currentTab == 1 ? 14 : 12,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
