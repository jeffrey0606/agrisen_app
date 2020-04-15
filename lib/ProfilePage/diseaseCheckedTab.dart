import 'dart:convert';

import 'package:agrisen_app/PlantDiseaseDetection/diseaseDetectionPage.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DiseaseCheckedHistory extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final String apiKey;
  DiseaseCheckedHistory({@required this.globalKey, @required this.apiKey});
  @override
  _DiseaseCheckedHistoryState createState() => _DiseaseCheckedHistoryState();
}

class _DiseaseCheckedHistoryState extends State<DiseaseCheckedHistory> {
  bool _showMore = false, _isAHistoryIsOpen = false;

  int _currentIndex = 0;
  Future _getPrediction;

  @override
  void initState() {
    super.initState();
    _getPrediction = getPredictionHistory(widget.apiKey);
  }

  getPredictionHistory(String apiKey) async {
    return await http.get(
        'http://192.168.43.150/agrisen-api/index.php/Home/fetch_prediction_history',
        headers: {'api_key': apiKey});
  }

  String formatDate(String timestamp) {
    return DateFormat('yMd').add_jms().format(DateTime.parse(timestamp));
  }

  void _show(int index) {
    setState(() {
      if (_currentIndex == index) {
        if (_showMore) {
          _showMore = false;
          _isAHistoryIsOpen = false;
        } else {
          _showMore = true;
          _isAHistoryIsOpen = true;
        }
        _currentIndex = index;
      } else {
        if (_isAHistoryIsOpen) {
          _showMore = false;
          _showMore = true;
          _isAHistoryIsOpen = false;
        } else {
          _showMore = true;
          _isAHistoryIsOpen = true;
        }
        _currentIndex = index;
      }
    });
  }

  Widget PredictionInfos({String label, String description, Color colors}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          description,
          softWrap: true,
          maxLines: 4,
          style: TextStyle(
            color: colors,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _getPrediction,
      builder: (BuildContext buildContext, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                strokeWidth: 3,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              http.Response response = snapshot.data;
              final data = response.body.toString().isEmpty
                  ? null
                  : json.decode(response.body) as List<dynamic>;
              print(data);
              if (data != null && data.isNotEmpty) {
                return Container(
                  child: ListView.separated(
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      thickness: 2.0,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          if (index == 0)
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Disease Checked History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 8.0, left: 8.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 50,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 25),
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Total :',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  10, 17, 40, 1.0),
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            data.length.toString(),
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  10, 17, 40, 1.0),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 15,
                          ),
                          AnimatedContainer(
                            height: _currentIndex == index
                                ? _showMore ? 200 : 50
                                : 50,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'Date : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${formatDate(data[index]['timestamp'])}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${TimeAjuster.ajust(DateTime.parse(data[index]['timestamp']))}',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FlatButton.icon(
                                        icon: Icon(
                                          _currentIndex == index
                                              ? _showMore
                                                  ? Icons.expand_less
                                                  : Icons.expand_more
                                              : Icons.expand_more,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _show(index),
                                        label: Text(
                                          _currentIndex == index
                                              ? _showMore
                                                  ? 'see less'
                                                  : 'see more'
                                              : 'see more',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_showMore && _currentIndex == index)
                                    Expanded(
                                        child: Column(
                                      children: <Widget>[
                                        PredictionInfos(
                                          label: 'Crop :',
                                          colors: data[index]['disease_name']
                                                  .contains('healthy')
                                              ? Colors.green
                                              : Colors.red,
                                          description: data[index]['crop_name'],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        PredictionInfos(
                                          label: data[index]['disease_name']
                                                  .contains('healthy')
                                              ? 'No Disease :'
                                              : 'Disease :',
                                          description: data[index]
                                              ['disease_name'],
                                          colors: data[index]['disease_name']
                                                  .contains('healthy')
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        PredictionInfos(
                                          label: 'Confident At :',
                                          description:
                                              '${data[index]['confident_at']}%',
                                          colors: data[index]['disease_name']
                                                  .contains('healthy')
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 45,
                                          child: FlatButton.icon(
                                            icon: Icon(
                                              Icons.exit_to_app,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'See Solution',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            color: Colors.green,
                                            onPressed: () {
                                              widget.globalKey.currentState
                                                  .showBottomSheet(
                                                (BuildContext builder) {
                                                  return Container(
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: Stack(
                                                      children: <Widget>[
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 180,
                                                                color: Colors
                                                                    .black26,
                                                                width: double
                                                                    .infinity,
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    CachedNetworkImage(
                                                                      imageUrl:
                                                                          'http://192.168.43.150/agrisen-api/uploads/predictions/${data[index]['crop_image']}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                    Positioned(
                                                                      bottom: 5,
                                                                      right: 5,
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      child:
                                                                          FittedBox(
                                                                        child:
                                                                            CircleAvatar(
                                                                          maxRadius:
                                                                              50,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          child:
                                                                              SvgPicture.network(
                                                                            'http://www.agrisen.net/agrisen-api/uploads/crops/${data[index]['crop_name'].split(' ').join('')}.svg',
                                                                            width:
                                                                                60,
                                                                            height:
                                                                                60,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Solution',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              SolutionWidget(
                                                                disease: data[
                                                                        index][
                                                                    'disease_name'],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 5,
                                                          right: 0,
                                                          left: 0,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              Icons.expand_more,
                                                              color:
                                                                  Colors.white,
                                                              size: 35,
                                                            ),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                elevation: 10,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            } else if (snapshot.hasError) {
              print('custom err: ${snapshot.error}');
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'You have not done any health prediction on your crop yet. \n',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 18),
                          ),
                          TextSpan(
                            text:
                                'Please click on the button below to predict your crop health.',
                            style: TextStyle(
                                color: Colors.green,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton.icon(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    icon: ImageIcon(
                      AssetImage(
                        'assets/runTestIcon.png',
                      ),
                      color: Color.fromRGBO(237, 245, 252, 1.0),
                      size: 30,
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(DiseaseDetectionPage.nameRoute),
                    label: Text(
                      'disease check',
                      style: TextStyle(
                        color: Color.fromRGBO(237, 245, 252, 1.0),
                      ),
                    ),
                    color: Color.fromRGBO(10, 17, 40, 1.0),
                  )
                ],
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}

class SolutionWidget extends StatefulWidget {
  final String disease;
  SolutionWidget({@required this.disease, Key key}) : super(key: key);
  @override
  _SolutionWidgetState createState() => _SolutionWidgetState();
}

class _SolutionWidgetState extends State<SolutionWidget> {
  Future _getSolution;
  @override
  void initState() {
    super.initState();
    _getSolution = getSolution(widget.disease);
  }

  getSolution(String disease) async {
    final url =
        'http://192.168.43.150/agrisen-api/index.php/Home/fetch_disease_solution?disease=$disease';
    return await http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _getSolution,
      builder: (BuildContext buildContext, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                strokeWidth: 3,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              http.Response data = snapshot.data;
              final solution = json.decode(data.body);
              if (solution != null) {
                return Html(
                  data: solution['disease_solution'],
                );
              }
            } else if (snapshot.hasError) {
              print('custom err: ${snapshot.error}');
            }
            return Text('Please try again later something went wrong!');
          default:
            return Container();
        }
      },
    );
  }
}
