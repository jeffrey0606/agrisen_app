import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiseaseCheckedHistory extends StatefulWidget {
  @override
  _DiseaseCheckedHistoryState createState() => _DiseaseCheckedHistoryState();
}

class _DiseaseCheckedHistoryState extends State<DiseaseCheckedHistory> {
  bool _showMore = false, _isAHistoryIsOpen = false;

  int _currentIndex = 0;

  var dateTime = DateFormat('yMd').add_jms().format(DateTime.now());

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (BuildContext context, int index) => Divider(
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total :',
                                style: TextStyle(
                                  color: Color.fromRGBO(10, 17, 40, 1.0),
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '3',
                                style: TextStyle(
                                  color: Color.fromRGBO(10, 17, 40, 1.0),
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
              AnimatedContainer(
                height: _currentIndex == index ? _showMore ? 100 : 50 : 50,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('Date : $dateTime'),
                          ),
                          FlatButton(
                            onPressed: () => _show(index),
                            child: Text(
                              _currentIndex == index
                                  ? _showMore ? 'see less' : 'see more'
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
                          child: Center(
                            child: Text('Information from Transaction API.'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (index == 2)
                Divider(
                  thickness: 2.0,
                ),
            ],
          );
        },
      ),
    );
  }
}