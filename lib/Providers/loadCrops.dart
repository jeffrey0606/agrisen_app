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
          .get('http://161.35.10.255/agrisen-api/index.php/Home/fetch_carousel_images');
      if (response != null) {
        print('coarou: ${json.decode(response.body)}');
        _carouselImages = json.decode(response.body);
      }
      
    } catch (e) {
      print('error1 $e');
    }
    notifyListeners();
  }

  Future<void> fetchCrops() async{

    try{
      final url = 'http://161.35.10.255/agrisen-api/index.php/Home/fetch_crops';
      final response = await http.get(url);

      if(response != null){
        print('crops: ${json.decode(response.body)}');
        final result = json.decode(response.body);

        _cropsData = result;
        await _fetchCarouselImages();
      }
    }catch(err){
      print('error: $err');
      throw err;
    }
    notifyListeners();
  }
}