import 'dart:convert';
import 'dart:io';

import 'package:agrisen_app/ProfilePage/diseaseCheckedTab.dart';
import 'package:agrisen_app/ProfilePage/notificationTab.dart';
import 'package:agrisen_app/ProfilePage/questionsAskedTab.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../pickImage.dart';

import '../Providers/uploadFilesToServer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pickImage.dart';
import 'package:intl/intl.dart';
import './notifications.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

class HasLogin extends StatefulWidget {
  final Function alert;
  HasLogin({@required this.alert});
  @override
  _HasLoginState createState() => _HasLoginState();
}

enum MenuItems {
  settings,
  logout,
}

class _HasLoginState extends State<HasLogin> {
  bool _isLoading = true;
  Directory directory;
  ScrollController _scrollController;

  String apiKey = '';
  double appBarHeight = AppBar().preferredSize.height * 4;
  double offset = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();

    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.hasClients &&
        _scrollController.offset < appBarHeight) {
      setState(() {
        offset = _scrollController.offset;
      });
    }
  }

  bool once = true;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {
      _isLoading = true;
    });
    if (once) {
      final userProvider = Provider.of<UserInfos>(context);
      if (userProvider.userInfos['user_id'] == null) {
        print('object');
        await userProvider.getUser().then((_) {
          setState(() {
            _isLoading = false;
          });
        }).catchError((onError) {
          setState(() {
            _isLoading = false;
          });
          print('er: $onError');
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    once = false;
  }

  String reverseString(String string) {
    List<String> list = string.split('').reversed.toList();
    String temp = '';
    list.forEach((f) => temp += f);
    return temp;
  }

  void getImage(ImageSource imageSource, {int key, String profileImage}) async {
    final dir1 = await path_provider.getTemporaryDirectory();

    setState(() {
      directory = dir1;
    });

    File _image = await ImagePicker.pickImage(source: imageSource);

    final reversed = reverseString(_image.absolute.path)
        .replaceFirst(new RegExp(r'\w{0,10}[.]'), 'gpj.');

    _image = File(reverseString(reversed));

    final targetPath = dir1.absolute.path + '/${path.basename(_image.path)}';

    final result = await FlutterImageCompress.compressAndGetFile(
      _image.absolute.path,
      targetPath,
      format: CompressFormat.jpeg,
      quality: 50,
    );

    setState(() {
      uploadProfileImage(result, apiKey, profileImage);
    });
  }

  void uploadProfileImage(File image, String apikey, profileImage) async {
    setState(() {
      _isLoading = true;
    });

    var previousProfileImage = '';

    if (!profileImage.startsWith('https://') && profileImage.isNotEmpty) {
      previousProfileImage =
          '/${profileImage.substring(profileImage.lastIndexOf('/') + 1)}';
    }

    final url =
        'http://161.35.10.255/agrisen-api/index.php/Upload/upload_profile${previousProfileImage}';

    final formData = FormData.fromMap(
        {'profile_image': await MultipartFile.fromFile(image.path)});
    await Dio()
        .post(url,
            options: Options(headers: {'api_key': apikey}), data: formData)
        .then((response) {
      final result = json.decode(response.data);
      if (result.toString().contains('<p>')) {
        var s = '';
        s = result;
        var f = s.substring(3, s.length - 4);
        snakebar(f.contains('filetype')
            ? '$f Please enter a .png, .jpg of .jpeg image.'
            : f);
      } else {
        if (result) {
          setState(() {
            _isLoading = false;
            profileImage =
                'http://161.35.10.255/agrisen-api/uploads/profile_images/${path.basename(image.path)}';
          });
          snakebar('your profile image was updated successfully');
        } else if (result == '2') {
          setState(() {
            _isLoading = false;
          });
          snakebar('uploading profile image failed please try again');
        } else {
          setState(() {
            _isLoading = false;
          });
          snakebar('uploading profile image failed please try again');
        }
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      snakebar('something went wrong please try again later.');
      print('er: $onError');
    });
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  snakebar(String message) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
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
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    if (directory != null) await directory.delete(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserInfos>(context);
    final profileImage = userProvider.userInfos['profile_image'];
    final email = userProvider.userInfos['email'];
    final userId = userProvider.userInfos['user_id'];
    final userName = userProvider.userInfos['user_name'];
    final apiKey = userProvider.userInfos['api_key'];

    print(profileImage);
    return Scaffold(
      key: _globalKey,
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, boxIsScrolled) {
              return <Widget>[
                SliverAppBar(
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
                  forceElevated: true,
                  floating: true,
                  pinned: true,
                  snap: true,
                  elevation: 2,
                  title: Text('Agrisen'),
                  centerTitle: true,
                  expandedHeight: appBarHeight,
                  flexibleSpace: AnimatedCrossFade(
                    //opacity: (appBarHeight - offset) / appBarHeight,
                    //height: appBarHeight - (offset),
                    crossFadeState: offset < 50.0
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstCurve: Curves.easeIn,
                    secondCurve: Curves.easeOut,
                    duration: Duration(milliseconds: 100),
                    secondChild: Container(),
                    firstChild: Container(
                      margin: EdgeInsets.only(
                          top: AppBar().preferredSize.height - 18),
                      child: Column(children: <Widget>[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => PickImage.galleryOrCameraPick(
                                  context,
                                  getImage,
                                  profileImage: profileImage
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(60),
                                  ),
                                  child: Container(
                                    width: 115,
                                    height: 115,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(60),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.red,
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : profileImage == null
                                            ? SvgPicture.asset(
                                                'assets/SVGPics/profileImage.svg',
                                                width: 115,
                                              )
                                            : CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: profileImage,
                                                errorWidget:
                                                    (context, str, obj) {
                                                  return SvgPicture.asset(
                                                    'assets/SVGPics/profileImage.svg',
                                                    width: 115,
                                                  );
                                                },
                                                placeholder: (context, str) {
                                                  return SvgPicture.asset(
                                                    'assets/SVGPics/profileImage.svg',
                                                    width: 115,
                                                  );
                                                },
                                              ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        userName == null ? 'Username' : userName,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(10, 17, 40, 1.0),
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      email == null ? 'Email' : email,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(10, 17, 40, 1.0),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(bottom: 0),
                                onPressed: () => null,
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: Colors.blue,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 70),
                    labelStyle: TextStyle(
                      fontSize: 20,
                    ),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black45,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 16,
                    ),
                    isScrollable: true,
                    tabs: <Widget>[
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('QuestionsAsked'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Notifications'),
                            SizedBox(
                              width: 5,
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
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                    25,
                                  ),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    '3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('History'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                QuestionsAskedTab(
                  apiKey: apiKey,
                ),
                NotificationTab(),
                DiseaseCheckedHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
