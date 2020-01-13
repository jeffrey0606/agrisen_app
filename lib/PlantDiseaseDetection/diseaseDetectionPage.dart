import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'notPremium.dart';
import 'premium.dart';


class DiseaseDetectionPage extends StatefulWidget {
  static const nameRoute = 'DiseaseDetectionPage';

  @override
  _DiseaseDetectionPageState createState() => _DiseaseDetectionPageState();
}

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File image;
  bool _isDetecting = false;

  bool _busy = false;

  bool _hasRegisteredForPremium = true;

  void getImage(ImageSource imageSource) async {
    File _image = await ImagePicker.pickImage(source: imageSource);
    setState(() {
      image = _image;
      print(image);
    });
  }

  Future<void> galleryOrCameraPick() async {
    return showDialog<void>(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text(
            'Choose',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              decoration: TextDecoration.underline,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    getImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                    'From Camera',
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    getImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo),
                  title: Text(
                    'From Gallery',
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Exit',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  /*List<dynamic> _detectedDisease;

  Future<void> detectDisease() async {
    if (image != null) {
      setState(() {
        _isDetecting = true;
      });
      PlantsImageDetection imageDetection = PlantsImageDetection(image: image);
      await imageDetection.diseaseDetection().then((results) async {
        setState(() {
          _isDetecting = false;
          _detectedDisease = results;
        });
        print('results : $results');
        //await Tflite.close();
      }).catchError((onError) {
        setState(() {
          _isDetecting = false;
        });
        print('Errors1: $onError');
      });
    } else {
      print('please select an Image');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    //final appbarHeight = Scaffold.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => galleryOrCameraPick(),
        elevation: 5,
        child: Icon(
          Icons.camera,
          color: Color.fromRGBO(10, 17, 40, 1.0),
          size: 35,
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Health Check'),
            expandedHeight: 200,
            forceElevated: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.all(0),
              title: Text(
                'Potatoes Leaves',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              background: image != null
                  ? Image.file(
                      image,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.blue,
                    ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Disease name :',
                            style: TextStyle(
                              color: Color.fromRGBO(10, 17, 40, 1.0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              'corn maize cercospora leaf spot gray leaf spot .',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(10, 17, 40, 1.0),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _hasRegisteredForPremium ? Premium() : NotPremium(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*Center(
        child: _busy
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.white12,
                      child: Container(
                        alignment: Alignment.center,
                        child: image == null
                            ? Icon(
                                Icons.broken_image,
                                color: Colors.black12,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                      image: FileImage(
                                        image,
                                      ),
                                      fit: BoxFit.fill),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: _isDetecting
                          ? CircularProgressIndicator()
                          : _detectedDisease == null
                              ? Text('no information')
                              : Text(
                                  _detectedDisease.toString(),
                                ),
                    ),
                  )
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed: getImage,
              tooltip: 'add image',
              child: Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed: () => detectDisease(),
              tooltip: 'detect',
              child: Icon(Icons.send),
            ),
          ],
        ),
      ),*/
