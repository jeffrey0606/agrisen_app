import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite/tflite.dart';

class PlantsImageDetection {
  final File image;

  PlantsImageDetection({this.image});

  Uint8List imageToByteList(
          img.Image image, int inputSize, double mean, double std) {
        var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
        var buffer = Float32List.view(convertedBytes.buffer);
        int pixelIndex = 0;
        for (var i = 0; i < inputSize; i++) {
          for (var j = 0; j < inputSize; j++) {
            var pixel = image.getPixel(i, j);
            buffer[pixelIndex++] = (((pixel >> 16) & 0xFF) - mean) / std;
            buffer[pixelIndex++] = (((pixel >> 8) & 0xFF) - mean) / std;
            buffer[pixelIndex++] = (((pixel) & 0xFF) - mean) / std;
          }
        }
        return convertedBytes.buffer.asUint8List();
      }

  Future<void> loadModel() async {
    Tflite.close();
    try {
      var res = await Tflite.loadModel(
        model: 'assets/plant_disease_model1.tflite',
        labels: 'assets/plant_labels.txt',
      );
      print('res: $res');
    } catch (error) {
      print('could not load model : $error');
    }
  }

  Future<List<dynamic>> diseaseDetection() async {
    try {
      var imageBytes = await this.image.readAsBytes();
      img.Image image = img.decodeJpg(imageBytes);

      var recognitions = await Tflite.runModelOnBinary(
        binary: imageToByteList(image, 224, 127.5, 127.5), // required
        numResults: 6, // defaults to 5
        threshold: 0.05, // defaults to 0.1
        numThreads: 1, // defaults to 1
      );

      /*var recognitions = await Tflite.runModelOnImage(
        path: this.image.path,
        inputSize: 224,
        numChannels: 3,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 6,
        threshold: 0.05,
        numThreads: 1,
      );*/

      //await Tflite.close();

      return recognitions;
    } catch (error) {
      return throw error;
    }
  }

  /*FirebaseModelInterpreter interpreter = FirebaseModelInterpreter.instance;
    FirebaseModelManager manager = FirebaseModelManager.instance;
    try {
      //Download Conditions could be added here
      await manager
          .registerLocalModelSource(FirebaseLocalModelSource(
            assetFilePath: 'assets/plant_disease_model.tflit',
            modelName: 'plant-disease-model',
          ))
          .then((_) {
        print('surely');
      }).catchError((onError) {
        print('err: $onError');
      });
      var imageBytes = (await rootBundle.load('assets/testImage1.jpg')).buffer;
      print('imageBytes : $imageBytes');
      img.Image image = img.decodeJpg(imageBytes.asUint8List());
      print('image : $image');
      image = img.copyResize(image, height: 224, width: 224);
      print('image1 : $image');
      var results = await interpreter.run(
          remoteModelName: 'plant-diseases-detector',
          inputOutputOptions: FirebaseModelInputOutputOptions([
            FirebaseModelIOOption(FirebaseModelDataType.BYTE, [1, 224, 224, 3])
          ], [
            FirebaseModelIOOption(FirebaseModelDataType.BYTE, [1, 1001])
          ]),
          inputBytes: _imageToByteList(image));
      return results;
    } catch (error) {
      throw error;
    }
  }*/

  /*Uint8List _imageToByteList(img.Image image) {
    var _inputSize = 224;
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
  }*/
}
