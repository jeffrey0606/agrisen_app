import 'package:dio/dio.dart';
import 'package:path/path.dart';

class UploadFilesToServer {
  final String filePath;
  UploadFilesToServer({this.filePath});

  Future<dynamic> uploadFilesToServer() async {

    String fileName = basename(filePath);
    print('File base name: $fileName');

    try{
      FormData formData = FormData.fromMap({
        'file' : await MultipartFile.fromFile(filePath, filename: fileName)
      });

      Response response = await Dio().post('http://192.168.1.100/Agrisen_app/saveFiles.php',data: formData);
      print('File upload response: $response');
      if(response.data['status'] == false){
        throw '${response.data['message']}' ;
      }else{
        return response.data['downloadUrl'];
      }
    }catch(error){
      throw error;
    }
  }
}

class CustomException implements Exception{
  final String message;
  CustomException(this.message);
}

//windows 10.0.2.2
//hostname 192.168.1.100