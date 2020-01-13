import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Tiles/AskExpert/askExpert.dart';
import 'Tiles/DiseaseDtectionHistory/diseaseDetectionHistory.dart';
import 'Tiles/SteupArticle/setupArticle.dart';

class DrawerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.lightBlue[200],
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  SafeArea(
                    child: CircleAvatar(
                      child:
                          SvgPicture.asset('assets/SVGPics/profileImage.svg'),
                      maxRadius: 80,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pushNamed(DiseaseDetectionHistory.nameRoute),
              leading: ImageIcon(
                AssetImage('assets/runtestIcon.png'),
                color: Color.fromRGBO(10, 17, 40, 1.0),
                size: 30,
              ),
              title: Text(
                'Disease detection history',
                style: TextStyle(color: Color.fromRGBO(10, 17, 40, 1.0)),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pushNamed(SetupArticle.nameRoute),
              leading: Icon(
                Icons.mode_edit,
                color: Color.fromRGBO(10, 17, 40, 1.0),
                size: 30,
              ),
              title: Text(
                'Setup Article',
                style: TextStyle(color: Color.fromRGBO(10, 17, 40, 1.0)),
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pushNamed(AskExpert.nameRoute),
              leading: Icon(
                Icons.comment,
                color: Color.fromRGBO(10, 17, 40, 1.0),
                size: 30,
              ),
              title: Text(
                'Ask Expert',
                style: TextStyle(color: Color.fromRGBO(10, 17, 40, 1.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
