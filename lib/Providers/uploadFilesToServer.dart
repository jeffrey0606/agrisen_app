import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

class UploadFilesToServer {
  final String filePath;
  final List<String> filePaths;
  UploadFilesToServer({this.filePath, this.filePaths});

  Future<void> uploadTextFile() async {
    List<Object> files = [];
    String fileName = basename(filePath);
    print('File base name: $fileName');
    filePaths.forEach((filePath) async {
      String fileName = basename(filePath);
      print('File base name: $fileName');
      files.add(await MultipartFile.fromFile(filePath, filename: fileName));
    });

    try{
      FormData formData = FormData.fromMap({
        'files' : files,
        //'file' : await MultipartFile.fromFile(filePath, filename: fileName)
      });

      Response response = await Dio().post('http://10.0.2.2/Agrisensor_app/saveFiles.php',data: formData);
      print('File upload response: $response');

    }catch(error){
      throw error;
    }
  }
}