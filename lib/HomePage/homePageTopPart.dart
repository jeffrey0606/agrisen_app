import 'package:agrisen_app/Providers/dummyData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePageTopPart extends StatefulWidget {
  @override
  _HomePageTopPartState createState() => _HomePageTopPartState();
}

class _HomePageTopPartState extends State<HomePageTopPart> {
  final dummyData = DummyData().dummyData;
  final availableCrops = DummyData().availableCrops;

  int _currentPageIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
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
                  /*child: CarouselSlider(
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: Duration(seconds: 10),
                    enlargeCenterPage: true,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    items: dummyData.map((item) {
                      return Builder(
                        builder: (context) {
                          return Container();
                          /*return Image.network(
                            item.leadingImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );*/
                        },
                      );
                    }).toList(),
                  ),*/
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
                        children: dummyData.map((item) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  dummyData.indexOf(item) == _currentPageIndex
                                      ? Colors.pink
                                      : Colors.white38,
                              radius: 10.0,
                            ),
                          );
                        }).toList()),
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
                color: Color.fromRGBO(10, 17, 40, 1.0),
                fontWeight: FontWeight.w700,
                fontSize: 20,
                decoration: TextDecoration.underline),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Container(
          height: 150,
          margin: EdgeInsets.symmetric(horizontal: 1.5),
          child: ListView.separated(
            itemCount: availableCrops.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) {
              return VerticalDivider(
                endIndent: 45,
                indent: 45,
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
                      child: SvgPicture.asset(
                        availableCrops[index].icon,
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
                    availableCrops[index].name,
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
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
