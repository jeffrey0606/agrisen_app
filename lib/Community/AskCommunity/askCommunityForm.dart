import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:agrisen_app/imagesViewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../pickImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AskCommunityForm extends StatefulWidget {
  static const routeName = 'AskCommunityForm';

  @override
  _AskCommunityFormState createState() => _AskCommunityFormState();
}

class _AskCommunityFormState extends State<AskCommunityForm> {
  int questionLenght = 0, cropNamelenght = 0;
  String question = '', cropName = '';
  bool _isLoading = false;

  void getImage(ImageSource imageSource, {int key, String profileImage}) async {
    File _image = await ImagePicker.pickImage(source: imageSource);

    final properties = await FlutterNativeImage.getImageProperties(_image.path);
    final result = await FlutterNativeImage.compressImage(
      _image.path,
      quality: 70,
      targetHeight: properties.height,
      targetWidth: properties.width,
    );

    setState(() {
      _images.update(key, (_) => result);
    });
  }

  final _formKey = GlobalKey<FormState>();

  void _askHelp(BuildContext context, Map<String, dynamic> userInfos) async {
    print(userInfos);

    int i = 0;
    _images.forEach((key, value) {
      if (value != null) {
        i++;
      }
    });

    if (_images[5] != null) {
      if (i > 2) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          setState(() {
            _isLoading = true;
          });
          final formData = FormData.fromMap({
            'crop_images': [
              await MultipartFile.fromFile(_images[5].path),
              if (_images[4] != null)
                await MultipartFile.fromFile(_images[4].path),
              if (_images[3] != null)
                await MultipartFile.fromFile(_images[3].path),
              if (_images[2] != null)
                await MultipartFile.fromFile(_images[2].path),
              if (_images[1] != null)
                await MultipartFile.fromFile(
                  _images[1].path,
                ),
            ],
            'crop_name': cropName,
            'question': question,
          });

          await Dio()
              .post(
            'http://192.168.43.150/agrisen-api/index.php/Community/ask_help',
            data: formData,
            options: Options(
              headers: {
                'api_key': userInfos['api-key'],
              },
            ),
          )
              .then((response) async {
            final result = json.decode(response.data);

            if (result == null) {
              setState(() {
                _isLoading = false;
              });
              snakebar('Your question failed to be uploaded.');
            } else if (result) {
              setState(() {
                _images = {
                  1: null,
                  2: null,
                  3: null,
                  4: null,
                  5: null,
                };
                question = '';
                cropName = '';
                _isLoading = false;
              });
              snakebar('You Question has been uploaded successfully.');
            } else {
              setState(() {
                _isLoading = false;
              });
              snakebar(result);
            }
          }).catchError((err) {
            setState(() {
              _isLoading = false;
            });
            print('error: $err');
            snakebar('Please check your internet connection!');
          });
        }
      } else {
        snakebar('Atleast 2 altenative images are required !');
      }
    } else {
      snakebar('The Crop Cover Image is required !');
    }
  }

  snakebar(String message) {
    _scaffoldKey.currentState.showSnackBar(
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
            Expanded(
              child: Text(
                message,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<int, File> _images = {
    1: null,
    2: null,
    3: null,
    4: null,
    5: null,
  };

  @override
  Widget build(BuildContext context) {
    final userInfos =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        title: Text('Ask Help'),
        titleSpacing: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () => _askHelp(context, userInfos),
            icon: Icon(
              Icons.save,
              color: Color.fromRGBO(10, 17, 40, 1.0),
              size: 30,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Scrollbar(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .30,
                      color: Colors.black26,
                      child: _images[5] == null
                          ? Center(
                              child: Text('Crop\'s Cover Image'),
                            )
                          : Image.file(
                              _images[5],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 8.0),
                          child: RaisedButton.icon(
                            color: Color.fromRGBO(237, 245, 252, 1.0),
                            icon: Icon(
                              Icons.view_carousel,
                              color: Colors.blue,
                            ),
                            label: Text(
                              'View Images',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () {
                              int i = 0;
                              _images.forEach((key, value) {
                                if (value != null) {
                                  i++;
                                }
                              });

                              if (_images[5] != null) {
                                if (i > 2) {
                                  var tempImg = [];
                                  int index = 0;
                                  _images.entries.forEach((image) {
                                    if (image.value != null) {
                                      tempImg.insert(index, image.value);
                                      index++;
                                    }
                                  });
                                  if (tempImg.isNotEmpty) {
                                    Navigator.of(context).pushNamed(
                                      ImagesViewer.namedRoute,
                                      arguments: {
                                        'from': 'file',
                                        'images': tempImg.reversed.toList()
                                      },
                                    );
                                  }
                                } else {
                                  snakebar(
                                      'To have a view on Your crop\'s images you must have atleast 2 altenative images!');
                                }
                              } else {
                                snakebar(
                                    'To have a view on Your crop\'s images the Main Crop Image is required !');
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 140,
                          padding: EdgeInsets.only(right: 8.0),
                          child: RaisedButton.icon(
                            color: Color.fromRGBO(237, 245, 252, 1.0),
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                            label: Text(
                              _images[5] == null ? 'Add' : 'Change',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            onPressed: () => PickImage.galleryOrCameraPick(
                              context,
                              getImage,
                              key: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Please add atleast 2 other images to be more precise thanks.',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      child: CupertinoScrollbar(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _images.entries.map((images) {
                            return images.key == 5
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 160,
                                        color: Colors.blue,
                                        width: 200,
                                        margin: images.key == 1
                                            ? EdgeInsets.only(left: 15)
                                            : images.key == 4
                                                ? EdgeInsets.only(right: 15)
                                                : EdgeInsets.symmetric(
                                                    horizontal: 15),
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                              child: Text(
                                                '${images.key}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                            if (images.value != null)
                                              Image.file(
                                                images.value,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: FlatButton(
                                                  color: Color.fromRGBO(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                  splashColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    images.value == null
                                                        ? 'add'
                                                        : 'change',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    PickImage
                                                        .galleryOrCameraPick(
                                                      context,
                                                      getImage,
                                                      key: images.key,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: question,
                        onChanged: (text) {
                          setState(() {
                            questionLenght = text.length;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'the question is required.';
                          } else if (value.length > 300) {
                            return 'the question should not be more than 300 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            question = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'What\'s your Question',
                          counterText: '$questionLenght/300',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        minLines: 2,
                        maxLines: 4,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: cropName,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'a crop name is required.';
                          } else if (value.length > 30) {
                            return 'a crop name should not be more than 30 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            cropName = value;
                          });
                        },
                        onChanged: (text) {
                          setState(() {
                            cropNamelenght = text.length;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Crop\'s name',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                          counterText: '$cropNamelenght/30',
                        ),
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                          selectAll: true,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
