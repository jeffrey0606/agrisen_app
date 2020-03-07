import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoadCrops extends ChangeNotifier {
  List<dynamic> _cropsData = [];
  List<dynamic> _carouselImages = ['howpartsofap.jpg'];

  List<dynamic> get cropsData {
    return [..._cropsData];
  }

  List<dynamic> get carouselImages {
    return [..._carouselImages];
  }

  Future<void> _fetchCarouselImages() async {
    try {
      final response = await http
          .get('http://192.168.43.150/Agrisen_app/fetchCarouselImages.php');
      if (response != null) {
        _carouselImages = json.decode(response.body);
      }
      
    } catch (e) {
      print('error1 $e');
    }
    notifyListeners();
  }

  Future<void> fetchCrops() async{

    try{
      final url = 'http://192.168.43.150/Agrisen_app/AdimFormsApis/fetchCrops.php';
      final response = await http.get(url);

      if(response != null){
        final result = json.decode(response.body);

        if(result['status'] == 200){
          _cropsData = result['data'];
        }
        await _fetchCarouselImages();
      }
    }catch(err){
      print('error: $err');
      throw err;
    }
    notifyListeners();
  }
}