import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CropWidget extends StatelessWidget {
  final List<dynamic> cropsList;
  final Function prevent;
  CropWidget({this.cropsList, this.prevent});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Text(
            'This are the various Crops available for disease detection.',
            softWrap: true,
            style: TextStyle(
              color: Colors.blue, //Color.fromRGBO(10, 17, 40, 1.0),
              fontWeight: FontWeight.w700,
              fontSize: 20,
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
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification){
                if(ScrollNotification.metrics.axis == Axis.horizontal){
                  this.prevent(true);
                }
              },
              child: ListView.separated(
                itemCount: this.cropsList.length,
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
                            'http://192.168.43.150/agrisen-api/uploads/crops/${this.cropsList[index]['crop_image']}',
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
                        '${this.cropsList[index]['crop_name']}',
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
        ),
      ],
    );
  }
}

class CropSkeletonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Text(
            'This are the various Crops available for disease detection.',
            softWrap: true,
            style: TextStyle(
              color: Colors.blue, //Color.fromRGBO(10, 17, 40, 1.0),
              fontWeight: FontWeight.w700,
              fontSize: 20,
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
              itemCount: 5,
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
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlue,
                          strokeWidth: 1,
                        ),
                        backgroundColor: Color.fromRGBO(237, 245, 252, 1.0),
                        maxRadius: 50,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 15,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
