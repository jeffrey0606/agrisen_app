import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'notifications.dart';

class HasLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 56 / 3,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      child:
                          SvgPicture.asset('assets/SVGPics/profileImage.svg'),
                      maxRadius: 50,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Username',
                            style: TextStyle(
                              color: Color.fromRGBO(10, 17, 40, 1.0),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Color.fromRGBO(10, 17, 40, 1.0),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(bottom: 0),
                      onPressed: () => null,
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
              TabBar(
                indicatorColor: Colors.blue,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 70),
                labelStyle: TextStyle(
                  fontSize: 20,
                ),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black45,
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                ),
                tabs: <Widget>[
                  Tab(
                    text: 'me',
                  ),
                  Tab(
                    text: 'Transactions',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Me(),
                    Transactions(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  var dateTime = DateFormat('yMd').add_jms();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'starts : ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: '${dateTime.format(DateTime.now())}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 3,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'expires : ',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${dateTime.format(DateTime.now().add(Duration(days: 31)))}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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
