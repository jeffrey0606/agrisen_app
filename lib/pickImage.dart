import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {

  static Future<void> galleryOrCameraPick(BuildContext context, Function getImage ,{int key}) async {
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
                    
                    getImage(ImageSource.camera, key: key);
                    Navigator.of(context).pop();
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                    'From Camera',
                  ),
                ),
                ListTile(
                  onTap: () {
                    
                    getImage(ImageSource.gallery, key: key);
                    Navigator.of(context).pop();
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
}