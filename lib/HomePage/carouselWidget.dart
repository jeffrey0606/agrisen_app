import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarouselWidget extends StatefulWidget {
  final List<dynamic> carouselImages;
  CarouselWidget({this.carouselImages});
  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 180,
          width: double.infinity,
          //margin: EdgeInsets.symmetric(horizontal: 5),
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
                  items: widget.carouselImages.map((item) {
                    return Builder(
                      builder: (context) {
                        return CachedNetworkImage(
                          key: Key(item),
                          imageUrl: 'http://161.35.10.255/agrisen-api/carousel_images/$item',
                          errorWidget: (context, str, obj) {
                            return Image.asset(
                              'assets/imageNotAvailable.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                          placeholder: (context, str) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor: Colors.lightBlue,
                                  strokeWidth: 1,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text('Loading...')
                              ],
                            );
                          },
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
                    children: widget.carouselImages.map((item) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: CircleAvatar(
                          backgroundColor:
                              widget.carouselImages.indexOf(item) ==
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
        )
      ],
    );
  }
}

class CarouselSkeletonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List temp = List(4);
    return Column(
      children: <Widget>[
        Container(
          height: 180,
          width: double.infinity,
          //margin: EdgeInsets.symmetric(horizontal: 5),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.lightBlue,
                      strokeWidth: 1,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Loading...')
                  ],
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
                    children: temp.map((item) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white38,
                          radius: 10.0,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
