import 'dart:convert';
import 'dart:io';

import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  File image;
  int questionLenght = 0, cropNamelenght = 0;
  String question = '', cropName = '';
  bool _isLoading = false;

  void getImage(ImageSource imageSource) async {
    final dir1 = await path_provider.getTemporaryDirectory();

    File _image = await ImagePicker.pickImage(source: imageSource);
    print('before: ${_image.absolute.path}');
    final reversed = reverseString(_image.absolute.path)
        .replaceFirst(new RegExp(r'\w{0,10}[.]'), 'gpj.');
    _image = File(reverseString(reversed));
    print('after: ${_image.absolute.path}');

    final targetPath = dir1.absolute.path + '/${basename(_image.path)}';
    final result = await FlutterImageCompress.compressAndGetFile(
        _image.absolute.path, targetPath,
        format: CompressFormat.jpeg, quality: 50);

    setState(() {
      image = result;
      print(dir1.listSync());
      print('before: ${_image.lengthSync()} after: ${image.lengthSync()}');
    });
  }

  String reverseString(String string) {
    List<String> list = string.split('').reversed.toList();
    String temp = '';
    list.forEach((f) => temp += f);
    return temp;
  }

  final _formKey = GlobalKey<FormState>();

  void _askHelp(BuildContext context, Map<String, dynamic> userInfos) async {
    print(userInfos);

    if (image != null) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        final formData = FormData.fromMap({
          'crop_image': await MultipartFile.fromFile(
            image.path,
            filename: basename(image.path),
          ),
          'askHelp': json.encode({'crop_name': cropName, 'question': question}),
        });

        await Dio()
            .post(
          'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/askHelp.php',
          data: formData,
          options: Options(
            headers: {
              'api_key': userInfos['api-key'],
            },
          ),
        )
            .then((response) async {

          final result = response.data;

          if (result['status'] == 200) {
            final dir = await path_provider.getTemporaryDirectory();

            if (image != null) {
              await Directory(dir.absolute.path).delete(recursive: true);
            }

            await Provider.of<LoadHelps>(context, listen: false).fetchHelps().then((_) {
              setState(() {
                image = null;
                question = '';
                cropName = '';
                _isLoading = false;
              });
            });
          } else {
            setState(() {
              _isLoading = false;
            });
            snakebar('This image already exist please change it');
          }
        }).catchError((err) {
          setState(() {
            _isLoading = false;
          });
          print('error: $err');
        });
      }
    } else {
      snakebar('an image of the crop is required.');
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
            Text(message),
          ],
        ),
      ),
    );
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfos =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    final helps = Provider.of<LoadHelps>(context)
        .getAllYourAskHelps(userInfos['api-key']);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        title: Text('Form'),
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
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .30,
                    color: Colors.black26,
                    child: image == null
                        ? Center(
                            child: Text('Plant\'s Image'),
                          )
                        : Image.file(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
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
                          image == null ? 'Add' : 'Change',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () =>
                            PickImage.galleryOrCameraPick(context, getImage),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                        } else if (value.length > 200) {
                          return 'the question should not be more than 200 characters.';
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
                        counterText: '$questionLenght/200',
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
                          counterText: '$cropNamelenght/30'),
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
                    height: 30,
                  ),
                  if (helps != [])
                    ...helps.map((help) {
                      final index = helps.indexOf(help);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            if (index == 0)
                              Column(
                                children: <Widget>[
                                  Text(
                                    helps != []
                                        ? '${helps[0]['user_name']} below is the list of the helps you asked the Community'
                                        : '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ListTile(
                              leading: Image.network(
                                'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${help['crop_image']}',
                                fit: BoxFit.cover,
                                width: 90,
                              ),
                              title: Text(
                                help['question'].endsWith('?')
                                    ? help['question']
                                    : '${help['question']} ?',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(help['crop_name']),
                              trailing: FittedBox(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () => null,
                                    ),
                                    Text(
                                      'delete',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider()
                          ],
                        ),
                      );
                    }).toList()
                ],
              ),
            ),
          ),
          if(_isLoading)Container(
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
