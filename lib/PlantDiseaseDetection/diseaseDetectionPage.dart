import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:agrisen_app/Community/AskCommunity/askCommunityForm.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/pickImage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mlkit/mlkit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DiseaseDetectionPage extends StatefulWidget {
  static const nameRoute = 'DiseaseDetectionPage';

  @override
  _DiseaseDetectionPageState createState() => _DiseaseDetectionPageState();
}

class ObjectDetectionLabel {
  String label;
  double confidence;
  String cropName;

  ObjectDetectionLabel(
      {@required this.label,
      @required this.confidence,
      @required this.cropName});
}

const List<String> CROP_NAMES = [
  'apple',
  'corn maize',
  'blueberry',
  'cherry',
  'grape',
  'orange',
  'peach',
  'pepper bell',
  'potato',
  'raspberry',
  'soybean',
  'squash powdery',
  'strawberry',
  'tomato'
];

class _DiseaseDetectionPageState extends State<DiseaseDetectionPage> {
  File image;
  FirebaseModelInterpreter interpreter;
  FirebaseModelManager manager;
  List<String> labels;
  ObjectDetectionLabel _result;
  bool _isPredicting = false, _changeColor = false, _isSaving = false;
  Future _solution;

  @override
  void initState() {
    interpreter = FirebaseModelInterpreter.instance;
    manager = FirebaseModelManager.instance;

    manager.registerRemoteModelSource(
      FirebaseRemoteModelSource(
        modelName: 'test_model1',
        enableModelUpdates: true,
      ),
    );

    rootBundle.loadString('assets/plant_labels.txt').then((string) {
      setState(() {
        labels = string.split('\n');
      });
    });

    super.initState();
  }

  Future<Uint8List> imageToByteListFloat(File file, int _inputSize) async {
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 80, targetWidth: _inputSize, targetHeight: _inputSize);
    var bytes = compressedFile.readAsBytesSync();
    var decoder = img.findDecoderForData(bytes);
    img.Image image = decoder.decodeImage(bytes);
    var convertedBytes = Float32List(1 * _inputSize * _inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < _inputSize; i++) {
      for (var j = 0; j < _inputSize; j++) {
        var pixel = image.getPixel(i, j);
        buffer[pixelIndex] = ((pixel >> 16) & 0xFF) / 255;
        pixelIndex += 1;
        buffer[pixelIndex] = ((pixel >> 8) & 0xFF) / 255;
        pixelIndex += 1;
        buffer[pixelIndex] = ((pixel) & 0xFF) / 255;
        pixelIndex += 1;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  void startPridiction(File file) async {
    setState(() {
      _isPredicting = true;
    });
    try {
      var bytes = await imageToByteListFloat(file, 224);
      final b64 = base64Encode(bytes);
      //print(b64);
      var results = await interpreter.run(
        remoteModelName: 'test_model1',
        inputOutputOptions: FirebaseModelInputOutputOptions(
          <FirebaseModelIOOption>[
            FirebaseModelIOOption(
                FirebaseModelDataType.FLOAT32, [1, 224, 224, 3])
          ],
          <FirebaseModelIOOption>[
            FirebaseModelIOOption(FirebaseModelDataType.FLOAT32, [1, 38])
          ],
        ),
        inputBytes: bytes,
      );

      List<ObjectDetectionLabel> currentLabels = [];
      for (int i = 0; i < results[0][0].length; i++) {
        if (results[0][0][i] > 0) {
          currentLabels.add(new ObjectDetectionLabel(
            label: labels[i],
            confidence: results[0][0][i] / 0.01,
            cropName: CROP_NAMES
                .firstWhere((cropName) => labels[i].contains(cropName)),
          ));
        }
      }

      currentLabels.sort((l1, l2) => (l2.confidence - l1.confidence).floor());

      currentLabels.removeWhere((test) => test.confidence < 40.0);

      currentLabels.forEach((f) {
        print(
            '${currentLabels.indexOf(f)}. label: ${f.label} || crop name: ${f.cropName} || confident: ${f.confidence}\n');
      });

      if (currentLabels.isEmpty) {
        setState(() {
          _isPredicting = false;
        });
        snackBar(_globalKey, 'no result was found');
      } else {
        setState(() {
          _isPredicting = false;
          _result = currentLabels[0];
          _solution = getSolution(currentLabels[0].label);
        });
      }
    } catch (e) {
      print('object err: $e');
    }
  }

  void getImage(ImageSource imageSource, {int key, String profileImage}) async {
    File _image = await ImagePicker.pickImage(source: imageSource);

    setState(() {
      image = _image;
    });

    startPridiction(_image);
  }

  String reverseString(String string) {
    List<String> list = string.split('').reversed.toList();
    String temp = '';
    list.forEach((f) => temp += f);
    return temp;
  }

  snackBar(GlobalKey<ScaffoldState> globalKey, String message) {
    globalKey.currentState.showSnackBar(
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
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  getSolution(String disease) async {
    final url =
        'http://192.168.43.150/agrisen-api/index.php/Home/fetch_disease_solution?disease=$disease';
    return await http.get(url);
  }

  initializeParams() {
    setState(() {
      _result = null;
      image = null;
    });
  }

  savePrediction(
      {String apiKey,
      String cropName,
      String diseaseName,
      String confidentAt,
      File cropImage}) async {
    final properties =
        await FlutterNativeImage.getImageProperties(cropImage.path);
    final result = await FlutterNativeImage.compressImage(
      cropImage.path,
      quality: 70,
      targetHeight: properties.height,
      targetWidth: properties.width,
    );
    final formData = FormData.fromMap({
      'crop_image': await MultipartFile.fromFile(result.path),
    });
    final url =
        'http://192.168.43.150/agrisen-api/index.php/Home/upload_predicted_image';
    setState(() {
      _isSaving = true;
    });
    await Dio().post(url, data: formData).then((response) async {
      final data = json.decode(response.data);
      print(data);
      if (data['uploadOk'] == 1) {
        final _url =
            'http://192.168.43.150/agrisen-api/index.php/Home/insert_new_prediction';
        await http.post(_url, body: {
          'crop_name': cropName,
          'disease_name': diseaseName,
          'confident_at': confidentAt,
          'crop_image': basename(result.path),
        }, headers: {
          'api_key': apiKey
        }).then((_) {
          setState(() {
            _isSaving = false;
          });
          snackBar(_globalKey,
              'Your prediction information were saved successfully');
        }).catchError((onError) {
          setState(() {
            _isSaving = false;
          });
          snackBar(_globalKey, 'your information could not be save');
        });
      } else {
        setState(() {
          _isSaving = false;
        });
        snackBar(_globalKey, data['msg']);
      }
    }).catchError((onError) {
      setState(() {
        _isSaving = false;
      });
      print(onError);
      snackBar(_globalKey, 'Something went wrong please try again later');
    });
  }

  Widget PredictionInfos({String label, String description, Color colors}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          description,
          softWrap: true,
          maxLines: 4,
          style: TextStyle(
            color: colors,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final userInfos = Provider.of<UserInfos>(context);
    final apiKey = userInfos.userInfos['api_key'];
    return Scaffold(
      key: _globalKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PickImage.galleryOrCameraPick(
            context,
            getImage,
            initilizeParams: initializeParams,
          );
        },
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
            title: Text('Disease Check'),
            expandedHeight: image == null
                ? 0
                : orientation == Orientation.portrait ? 200 : 130,
            forceElevated: true,
            pinned: true,
            titleSpacing: 0,
            iconTheme: IconThemeData(
              color: Color.fromRGBO(10, 17, 40, 1.0),
            ),
            textTheme: TextTheme(
              title: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 23,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: image != null
                  ? Stack(
                      children: <Widget>[
                        Image.file(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        if (_result != null)
                          Positioned(
                            bottom: 5,
                            right: 5,
                            height: 60,
                            width: 60,
                            child: FittedBox(
                              child: CircleAvatar(
                                maxRadius: 50,
                                backgroundColor: Colors.white,
                                child: SvgPicture.network(
                                  'http://192.168.43.150/agrisen-api/uploads/crops/${_result.cropName.split(' ').join('')}.svg',
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: AppBar().preferredSize.height * 1.66,
                          child: Container(
                            color: Colors.white38,
                          ),
                        )
                      ],
                    )
                  : Container(
                      color: Colors.white,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: _result != null && !_isPredicting
                ? Stack(
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            PredictionInfos(
                              label: 'Crop :',
                              colors: _result.label.contains('healthy')
                                  ? Colors.green
                                  : Colors.red,
                              description: _result.cropName,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            PredictionInfos(
                              label: _result.label.contains('healthy')
                                  ? 'No Disease :'
                                  : 'Disease :',
                              description: _result.label,
                              colors: _result.label.contains('healthy')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            PredictionInfos(
                              label: 'Confident At :',
                              description:
                                  '${_result.confidence.round().toString()}%',
                              colors: _result.label.contains('healthy')
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Solution',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FutureBuilder(
                              future: _solution,
                              builder: (BuildContext buildContext,
                                  AsyncSnapshot<dynamic> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      http.Response data = snapshot.data;
                                      final solution = json.decode(data.body);
                                      if (solution != null) {
                                        return Column(
                                          children: <Widget>[
                                            SizedBox(
                                              width: double.infinity,
                                              height: 45,
                                              child: FlatButton.icon(
                                                icon: Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  'Save your prediction',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                color: Colors.green,
                                                onPressed: () {
                                                  if (apiKey != null) {
                                                    savePrediction(
                                                      apiKey: apiKey,
                                                      confidentAt: _result
                                                          .confidence
                                                          .floor()
                                                          .toString(),
                                                      cropImage: image,
                                                      cropName:
                                                          _result.cropName,
                                                      diseaseName:
                                                          _result.label,
                                                    );
                                                  } else {
                                                    snackBar(_globalKey,
                                                        'You most create or login to your agrisen account first.');
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Html(
                                              data:
                                                  solution['disease_solution'],
                                            ),
                                          ],
                                        );
                                      }
                                      return Column(
                                        children: <Widget>[
                                          Text(
                                            'There is no solution available for this disease for the moment.',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          FlatButton.icon(
                                            icon: Icon(
                                              Icons.help_outline,
                                              color: Color.fromRGBO(
                                                  10, 17, 40, 1.0),
                                            ),
                                            onPressed: () {
                                              if (apiKey == null) {
                                                snackBar(_globalKey,
                                                    'You most create or login to your agrisen account first.');
                                              } else {
                                                Navigator.pushNamed(
                                                  context,
                                                  AskCommunityForm.routeName,
                                                  arguments: {
                                                    'api-key': apiKey
                                                  },
                                                );
                                              }
                                            },
                                            label: Text(
                                              'Ask Community',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    10, 17, 40, 1.0),
                                                fontSize: 16,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Color.fromRGBO(
                                                    10, 17, 40, 1.0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'something went wrong please try again letter');
                                    }
                                    return Text(
                                        'something went wrong please try again letter');
                                  default:
                                    return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_isSaving)
                        Container(
                          color: Colors.black38,
                          height: MediaQuery.of(context).size.height -
                              (image != null
                                  ? orientation == Orientation.portrait
                                      ? 200
                                      : 130
                                  : 0),
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.green,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        (image != null
                            ? orientation == Orientation.portrait ? 200 : 130
                            : 0),
                    child: Center(
                      child: _isPredicting
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.green,
                              strokeWidth: 3,
                            )
                          : Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      width: 3,
                                      style: BorderStyle.solid,
                                    ),
                                    right: BorderSide(
                                      color: Colors.green,
                                      width: 3,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Please take a close picture of the infected plant\'s leaves.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black12,
                                        offset: Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
