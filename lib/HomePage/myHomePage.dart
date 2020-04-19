import 'dart:convert';

import 'package:agrisen_app/HomePage/articlesWidget.dart';
import 'package:agrisen_app/HomePage/carouselWidget.dart';
import 'package:agrisen_app/HomePage/cropsWidget.dart';
import 'package:agrisen_app/Providers/loadNotification.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final Function alert;
  final Function changeItemView;

  Home({@required this.alert, this.changeItemView});

  @override
  _HomeState createState() => _HomeState();
}

enum MenuItems {
  settings,
  logout,
}

class _HomeState extends State<Home> {
  var _showAppBar = true;

  Future _carouselImages, _cropsData, _articleData;

  _getCarouselImages() async {
    return await http.get(
        'http://192.168.43.150/agrisen-api/index.php/Home/fetch_carousel_images');
  }

  _getCrops() async {
    return await http
        .get('http://192.168.43.150/agrisen-api/index.php/Home/fetch_crops');
  }

  _getArticles() async {
    return await http
        .get('http://192.168.43.150/agrisen-api/index.php/Home/fetch_articles');
  }

  changeItemView(bool show) {
    setState(() {
      _showAppBar = show;
    });
  }

  bool _prevent = false;

  preventCropScroll(bool prevent) {
    setState(() {
      _prevent = prevent;
    });
  }

  bool once = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (once) {
      await Provider.of<LoadNotifications>(context, listen: false).fetchNotificationDetails();
      final userProvider = Provider.of<UserInfos>(context, listen: false);
      if (userProvider.userInfos['user_id'] == null) {
        await userProvider.getUser();
      }
    }
    once = false;
  }

  @override
  void initState() {
    _carouselImages = _getCarouselImages();
    _cropsData = _getCrops();
    _articleData = _getArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(AppBar().preferredSize.width, AppBar().preferredSize.height),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _showAppBar
              ? AppBar().preferredSize.height + AppBar().preferredSize.height
              : 0,
          child: AppBar(
            title: Text('Agrisen'),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton<MenuItems>(
                onSelected: (items) {
                  switch (items) {
                    case MenuItems.logout:
                      widget.alert();
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
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (UserScrollNotification) {
          if (!_prevent) {
            if (UserScrollNotification.direction == ScrollDirection.forward) {
              setState(() {
                widget.changeItemView(false);
                changeItemView(false);
              });
            } else if (UserScrollNotification.direction ==
                ScrollDirection.idle) {
              setState(() {
                widget.changeItemView(true);
                changeItemView(true);
              });
            } else if (UserScrollNotification.direction ==
                ScrollDirection.reverse) {
              setState(() {
                widget.changeItemView(false);
                changeItemView(false);
              });
            }
          }
          return;
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /*FutureBuilder<dynamic>(
                future: _carouselImages,
                builder: (BuildContext buildContext,
                    AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CarouselSkeletonWidget();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        http.Response data = snapshot.data;
                        return CarouselWidget(
                          carouselImages: json.decode(data.body),
                        );
                      } else if (snapshot.hasError) {
                        print('custom err: ${snapshot.error}');
                      }
                      return Text('no data available');
                    default:
                      return CarouselSkeletonWidget();
                  }
                },
              ),*/
              SizedBox(
                height: 15.0,
              ),
              FutureBuilder<dynamic>(
                future: _cropsData,
                builder: (BuildContext buildContext,
                    AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CropSkeletonWidget();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        http.Response data = snapshot.data;
                        return CropWidget(
                          cropsList: json.decode(data.body),
                          prevent: preventCropScroll,
                        );
                      } else if (snapshot.hasError) {
                        print('custom err: ${snapshot.error}');
                      }
                      return Text('no data available');
                    default:
                      return Container();
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              FutureBuilder<dynamic>(
                future: _articleData,
                builder: (BuildContext buildContext,
                    AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return ArticlesSkeletonWidget();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        http.Response data = snapshot.data;
                        return ArticlesWidget(
                          articlesData: json.decode(data.body),
                        );
                      } else if (snapshot.hasError) {
                        print('custom err: ${snapshot.error}');
                      }
                      return Text('no data available');
                    default:
                      return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
