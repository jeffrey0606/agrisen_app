import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  _HasLoginState createState() => _HasLoginState();
}

class _HasLoginState extends State<HasLogin> {
  File image;
  bool isUploading = false, once = true;
  String imageUrl,
      userName = 'Username',
      email = 'Email',
      profileImage = '',
      apiKey = '';

  @override
  void didChangeDependencies() async {
    if (once) {
      final sharedPref = await SharedPreferences.getInstance();

      if (sharedPref.containsKey('userInfos')) {
        final userinfos = json.decode(sharedPref.getString('userInfos'));
        setState(() {
          apiKey = userinfos['api-key'];
        });
      }

      if (apiKey.isNotEmpty) {
        await getUserInfos();
      }
    }

    once = false;
    super.didChangeDependencies();
  }

  Future<void> getUserInfos() async {
    try {
      final url =
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/getUserInfos.php';
      final response = await http.get(url, headers: {'api_key': apiKey});

      if (response != null) {
        final result = json.decode(response.body);

        if (result['status'] == 200) {
          final tempProfile = result['userInfos']['profile_image'];
          setState(() {
            userName = result['userInfos']['user_name'];
            email = result['userInfos']['email'];
            profileImage = tempProfile.toString().isEmpty
                ? ''
                : tempProfile.toString().startsWith('https://')
                    ? tempProfile
                    : 'http://$tempProfile';
          });
        }
      }
    } catch (e) {
      print('error: $e');
    }
  }

  void getImage(ImageSource imageSource) async {
    File _image = await ImagePicker.pickImage(source: imageSource);
    /*var targetPath = '${_image.path.substring(0,_image.path.length - 6)}${Random().nextInt(200)}${DateTime.now().toIso8601String()}${_image.path.substring(_image.path.length - 4)}';
    var result = await FlutterImageCompress.compressAndGetFile(_image.absolute.path, targetPath, quality: 50);*/
    setState(() {
      image = _image;
      print(image);
    });

    uploadProfileImage();
  }

  void uploadProfileImage() async {
    if (image != null) {
      isUploading = true;
      final upload = UploadFilesToServer(filePath: image.path);

      await upload.uploadFilesToServer().then((url) {
        print('url: $url');
        setState(() {
          imageUrl = url;
          isUploading = false;
        });
      }).catchError((onError) {
        print(onError);
        setState(() {
          image = null;
          isUploading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(profileImage);
    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 56 / 3,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () =>
                          PickImage.galleryOrCameraPick(context, getImage),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(60),
                            ),
                          ),
                          child: profileImage.isEmpty
                              ? SvgPicture.network(
                                  'http://192.168.43.150/Agrisen_app/assetImages/profileImage.svg',
                                  width: 115,
                                )
                              : Image.network(
                                  profileImage,//+'?sz=3000&width=325&height=325',
                                  width: 115,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: Text(
                              userName,
                              style: TextStyle(
                                color: Color.fromRGBO(10, 17, 40, 1.0),
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            email,
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
              TabBar(
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
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Notifications'),
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
                                '1',
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
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    NotificationTab(),
                    DiseaseCheckHistory(),
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

class NotificationTab extends StatefulWidget {
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  var dateTime = DateFormat('yMd').add_jms();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () =>
                Navigator.of(context).pushNamed(Notifications.nameRoute),
            leading: CircleAvatar(
              maxRadius: 30,
            ),
            title: Text(
              'Message :',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
              'from :',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
      ),
    );
  }
}

class DiseaseCheckHistory extends StatefulWidget {
  @override
  _DiseaseCheckHistoryState createState() => _DiseaseCheckHistoryState();
}

class _DiseaseCheckHistoryState extends State<DiseaseCheckHistory> {
  bool _showMore = false, _isAHistoryIsOpen = false;

  int _currentIndex = 0;

  var dateTime = DateFormat('yMd').add_jms().format(DateTime.now());

  void _show(int index) {
    setState(() {
      if (_currentIndex == index) {
        if (_showMore) {
          _showMore = false;
          _isAHistoryIsOpen = false;
        } else {
          _showMore = true;
          _isAHistoryIsOpen = true;
        }
        _currentIndex = index;
      } else {
        if (_isAHistoryIsOpen) {
          _showMore = false;
          _showMore = true;
          _isAHistoryIsOpen = false;
        } else {
          _showMore = true;
          _isAHistoryIsOpen = true;
        }
        _currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 2.0,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              if (index == 0)
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Disease Checked History',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, left: 8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 25),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total :',
                                style: TextStyle(
                                  color: Color.fromRGBO(10, 17, 40, 1.0),
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '3',
                                style: TextStyle(
                                  color: Color.fromRGBO(10, 17, 40, 1.0),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              AnimatedContainer(
                height: _currentIndex == index ? _showMore ? 100 : 50 : 50,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('Date : $dateTime'),
                          ),
                          FlatButton(
                            onPressed: () => _show(index),
                            child: Text(
                              _currentIndex == index
                                  ? _showMore ? 'see less' : 'see more'
                                  : 'see more',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showMore && _currentIndex == index)
                        Expanded(
                          child: Center(
                            child: Text('Information from Transaction API.'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (index == 2)
                Divider(
                  thickness: 2.0,
                ),
            ],
          );
        },
      ),
    );
  }
}
