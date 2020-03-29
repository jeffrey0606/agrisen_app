import 'dart:convert';

import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/imagesViewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'ProfilePage/notifications.dart';
import 'MainAppContainer.dart';
import './HomePage/fullArticlePage.dart';
import './Community/CommentingPage/commentingPage.dart';
import './Community/AskCommunity/askCommunityForm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final plantdec = PlantsImageDetection();
    plantdec.loadModel().then((_) {
      print('ture');
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserInfos()),
        ChangeNotifierProvider.value(value: LoadHelps()),
        ChangeNotifierProvider.value(value: LoadComments()),
        ChangeNotifierProvider.value(value: LoadCommentedHelps()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Comfortaa',
          accentColor: Color.fromRGBO(237, 245, 252, 1.0),
          //primaryColor: Color.fromRGBO(237, 245, 252, 1.0),
          appBarTheme: AppBarTheme(
            color: Color.fromRGBO(237, 245, 252, 1.0),
            actionsIconTheme: IconThemeData(
              color: Color.fromRGBO(10, 17, 40, 1.0),
            ),
            textTheme: TextTheme(
              title: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 22,
                fontFamily: 'Comfortaa',
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        home: MainAppContainer(),
        routes: {
          FullArticlePage.nameRoute: (ctx) => FullArticlePage(),
          DiseaseDetectionPage.nameRoute: (ctx) => DiseaseDetectionPage(),
          Notifications.nameRoute: (ctx) => Notifications(),
          CommentingPage.routeName: (ctx) => CommentingPage(),
          AskCommunityForm.routeName: (ctx) => AskCommunityForm(),
          ImagesViewer.namedRoute: (ctx) => ImagesViewer(),
        },
      ),
    );
  }
}

/*File image;
  bool _isDetecting = false;

  bool _busy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _busy = true;
    });
    final plantdec = PlantsImageDetection();
    plantdec.loadModel().then((_) {
      setState(() {
        _busy = false;
      });
    });
  }

  void getImage() async {
    File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = _image;
    });
  }

  List<dynamic> _detectedDisease;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
      ),
    );
  }*/
