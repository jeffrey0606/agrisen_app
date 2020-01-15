import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'HomePage/myHomePage.dart';
import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/profilePage.dart';
import 'Community/community.dart';
import 'widgets/Drawer/Drawer.dart';


class MainAppContainer extends StatefulWidget {
  @override
  _MainAppContainerState createState() => _MainAppContainerState();
}

class _MainAppContainerState extends State<MainAppContainer> {
  int _currentTab = 0;
  final List<Widget> screens = [
    MyHomePage(),
    Community(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_currentTab == 1 ? null : AppBar(
        title: Text('Agrisen'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: DrawerLayout(),
      ),
      body: screens.elementAt(_currentTab),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/home.svg',
              height: _currentTab == 0 ? 25 : 15,
              color: _currentTab == 0 ? Color.fromRGBO(10, 17, 40, 1.0) : Colors.grey,
            ),
            title: Text('home'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/askcomunity.svg',
              height: _currentTab == 1 ? 30 : 20,
              color: _currentTab == 1 ? Color.fromRGBO(10, 17, 40, 1.0) : Colors.grey,
            ),
            title: Text('community'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/SVGPics/profile.svg',
              height: _currentTab == 2 ? 30 : 20,
              color: _currentTab == 2 ? Color.fromRGBO(10, 17, 40, 1.0) : Colors.grey,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(DiseaseDetectionPage.nameRoute),
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
