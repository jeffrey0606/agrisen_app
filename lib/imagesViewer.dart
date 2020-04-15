import 'dart:io';

import 'package:agrisen_app/MyCustomBadge.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ImagesViewer extends StatefulWidget {
  static const namedRoute = 'ImagesViewer';

  @override
  _ImagesViewerState createState() => _ImagesViewerState();
}

enum MenuItems {
  rotateLeft,
  rotateRight,
}

class _ImagesViewerState extends State<ImagesViewer> {
  bool isAppbarVisible = true;
  double _scale = 1.0;
  double _previousScale = 1.0;
  int rotate = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _images({Size size, Image image}) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      child: RotatedBox(
        quarterTurns: rotate,
        child: Transform(
            origin: rotate == 1 || rotate == 3
                ? Offset(size.height * 0.5, size.width * 0.5)
                : Offset(size.width * 0.5, size.height * 0.5),
            transform: Matrix4.diagonal3(
              Vector3(_scale, _scale, _scale),
            ),
            child: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final images =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onDoubleTap: () {
              if (_previousScale > 1.0 || _previousScale < 1.0) {
                _scale = 1.0;
                _previousScale = 1.0;
              } else if (_previousScale == 1.0) {
                _scale = 2.0;
                _previousScale = 2.0;
              }
              setState(() {});
            },
            onScaleStart: (ScaleStartDetails details) {
              setState(() {
                _previousScale = _scale;
              });
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
                _scale = _previousScale * details.scale;
              });
            },
            onScaleEnd: (ScaleEndDetails details) {
              setState(() {
                _previousScale = 1.0;
              });
            },
            onTap: () {
              setState(() {
                isAppbarVisible = !isAppbarVisible;
              });
            },
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: (images['images'] as List<dynamic>).map((image) {
                if (images['from'] == 'file') {
                  return _images(
                    size: size,
                    image: Image.file(
                      image,
                      fit: BoxFit.contain,
                    ),
                  );
                } else if (images['from'] == 'network') {
                  return _images(
                    size: size,
                    image: Image.network(
                      'http://192.168.43.150/agrisen-api/uploads/ask_helps/$image',
                      fit: BoxFit.contain,
                    ),
                  );
                }
              }).toList(),
            ),
          ),
          if (isAppbarVisible)
            Container(
              height: AppBar().preferredSize.height * 1.5,
              color: Colors.black.withOpacity(0.1),
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Images',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 20,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(3),
                              constraints: BoxConstraints(
                                minWidth: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  25,
                                ),
                              ),
                              child: FittedBox(
                                child: Text(
                                  (images['images'] as List<dynamic>).length.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<MenuItems>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onSelected: (items) {
                        switch (items) {
                          case MenuItems.rotateLeft:
                            setState(() {
                              switch (rotate) {
                                case 0:
                                  rotate = 1;
                                  break;
                                case 1:
                                  rotate = 2;
                                  break;
                                case 2:
                                  rotate = 3;
                                  break;
                                case 3:
                                  rotate = 0;
                                  break;
                              }
                            });
                            break;
                          case MenuItems.rotateRight:
                            setState(() {
                              switch (rotate) {
                                case 0:
                                  rotate = 3;
                                  break;
                                case 1:
                                  rotate = 0;
                                  break;
                                case 2:
                                  rotate = 1;
                                  break;
                                case 3:
                                  rotate = 2;
                                  break;
                              }
                            });
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<MenuItems>>[
                        PopupMenuItem<MenuItems>(
                          value: MenuItems.rotateLeft,
                          child: ListTile(
                            title: Text('Rotate Left'),
                            leading: Icon(Icons.rotate_left),
                          ),
                        ),
                        PopupMenuItem<MenuItems>(
                          value: MenuItems.rotateRight,
                          child: ListTile(
                            title: Text('Rotate Right'),
                            leading: Icon(Icons.rotate_right),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
