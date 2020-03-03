import 'dart:convert';

import 'package:agrisen_app/Providers/loadCrops.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomePageTopPart extends StatefulWidget {
  @override
  _HomePageTopPartState createState() => _HomePageTopPartState();
}

class _HomePageTopPartState extends State<HomePageTopPart> {
  bool once = true;

  int _currentPageIndex;

  @override
  void didChangeDependencies() async {
    if (once) {
      await Provider.of<LoadCrops>(context).fetchCrops();
    }
    once = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cropsData = Provider.of<LoadCrops>(context);
    final cropsList = cropsData.cropsData;
    final carouselImages = Provider.of<LoadCrops>(context).carouselImages;

    return cropsList == [] && carouselImages == []
        ? CircularProgressIndicator()
        : Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 160,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(163, 155, 168, 1.0),
                    style: BorderStyle.solid,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: CarouselSlider(
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                          enlargeCenterPage: true,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                          items: carouselImages.map((item) {
                            return Builder(
                              builder: (context) {
                                return Image.network(
                                  'http://192.168.43.150/Agrisen_app/carouselImages/$item',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 50,
                        child: Container(
                          color: Colors.black38,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: carouselImages.map((item) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: CircleAvatar(
                                  backgroundColor:
                                      carouselImages.indexOf(item) ==
                                              _currentPageIndex
                                          ? Colors.pink
                                          : Colors.white38,
                                  radius: 10.0,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'This are the various Crops and Fruits available for disease detection.',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.blue,//Color.fromRGBO(10, 17, 40, 1.0),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 150,
                margin: EdgeInsets.symmetric(horizontal: 1.5),
                child: Scrollbar(
                  child: ListView.separated(
                    itemCount: cropsList.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return VerticalDivider(
                        endIndent: 50,
                        indent: 30,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 2,
                            child: CircleAvatar(
                              child: SvgPicture.network(
                                'http://192.168.43.150/Agrisen_app/AdimFormsApis/CropImages/${cropsList[index]['image_name']}',
                                width: 60,
                              ),
                              backgroundColor: Color.fromRGBO(237, 245, 252, 1.0),
                              maxRadius: 50,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${cropsList[index]['crop_name']}',
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: double.infinity,
                child: Text(
                  'Learn how to plant your crops with our Articles.',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,//Color.fromRGBO(10, 17, 40, 1.0),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
  }
}
