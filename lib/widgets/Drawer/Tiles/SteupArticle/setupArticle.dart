import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class SetupArticle extends StatefulWidget {
  static const nameRoute = 'SetupArticle';

  @override
  _SetupArticleState createState() => _SetupArticleState();
}

class _SetupArticleState extends State<SetupArticle> {
  static const margin = 4.0;
  static const padding = 1.0;
  static const wmargin = (margin + padding) * 2;

  String document;
  /// render at 100 dpi
  static const scale = 100.0 / 72.0;


  File _image;
  bool _loadingFile = false;

  void _getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _saveFileToServer() async {
    File file = await FilePicker.getFile(type: FileType.ANY);
    print('File path: $file');
    // Read the file
    setState(() {
      _loadingFile = true;
      document = file.path;
    });
    /*UploadFilesToServer upload = new UploadFilesToServer(filePath: file.path);
    await upload.uploadTextFile().catchError((onError) {
      print('Error while uploading: $onError');
    });
    await file.readAsString(encoding: Utf8Codec(allowMalformed: true)).then((contents) {
      //print('contents: $contents');
      setState(() {
        _loadingFile = false;
        //document = contents;
      });
    }).catchError((onError) {
      print('could not read into file : $onError');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Article'),
        actions: <Widget>[
          RaisedButton(
              onPressed: () => _saveFileToServer(),
              child: Text('data'),
            ),
        ],
      ),
      body: Center(
          //children: <Widget>[
            /*Container(
              height: 230,
              color: Colors.black12,
              child: Stack(
                children: <Widget>[
                  _image == null
                      ? Container()
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    top: 0,
                    right: 6,
                    child: FlatButton.icon(
                      color: Colors.lightBlueAccent,
                      onPressed: () => _getImage(),
                      label: Text(
                        _image == null ? 'add' : 'change',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/SVGPics/pickFromGallery.svg',
                        height: 30,
                        color: Colors.white,
                      ),
                      //color: Colors.white10,
                    ),
                  ),
                  _image == null
                      ? Container(
                          width: double.infinity,
                          //color: Colors.black12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/SVGPics/brokenImageIcon.svg',
                                height: 80,
                              ),
                            ],
                          ),
                        )
                      : _image == null
                          ? Container(
                              color: Colors.black12,
                            )
                          : Container(),
                ],
              ),
            ),*/
            child: PdfDocumentLoader(              
                        filePath: document,
                        documentBuilder: (context, pdfDocument, pageCount) =>
                            LayoutBuilder(
                          builder: (context, constraints) => ListView.builder(
                            itemCount: pageCount,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.all(margin),
                              padding: EdgeInsets.all(padding),
                              color: Colors.black12,
                              child: PdfPageView(
                                pdfDocument: pdfDocument,
                                pageNumber: index + 1,
                                // calculateSize is used to calculate the rendering page size
                                calculateSize:
                                    (pageWidth, pageHeight, aspectRatio) =>
                                        Size(
                                            constraints.maxWidth - wmargin,
                                            (constraints.maxWidth - wmargin) /
                                                aspectRatio),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            /*Expanded(
              child: SingleChildScrollView(
                child: _loadingFile
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          document == null ? 'no file' : document,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
              ),
            )*/
          //],
    );
  }
}
