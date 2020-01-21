import 'dart:io';

import '../../pickImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AskCommunityForm extends StatefulWidget {
  static const routeName = 'AskCommunityForm';

  @override
  _AskCommunityFormState createState() => _AskCommunityFormState();
}

class _AskCommunityFormState extends State<AskCommunityForm> {
  File image;

  void getImage(ImageSource imageSource) async {
    File _image = await ImagePicker.pickImage(source: imageSource);
    /*var targetPath = '${_image.path.substring(0,_image.path.length - 6)}${Random().nextInt(200)}${DateTime.now().toIso8601String()}${_image.path.substring(_image.path.length - 4)}';
    var result = await FlutterImageCompress.compressAndGetFile(_image.absolute.path, targetPath, quality: 50);*/
    setState(() {
      image = _image;
      print(image);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        title: Text('Form'),
        actions: <Widget>[
          IconButton(
            onPressed: () => null,
            icon: Icon(
              Icons.save,
              color: Color.fromRGBO(10, 17, 40, 1.0),
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                  decoration: InputDecoration(
                    labelText: 'What\'s your Question',
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
                  decoration: InputDecoration(
                    labelText: 'Plant\'s name',
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
