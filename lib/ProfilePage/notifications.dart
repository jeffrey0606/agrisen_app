import 'dart:async';
import 'dart:convert';

import 'package:agrisen_app/Providers/loadNotification.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  static String nameRoute = 'Notifications';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Duration remainingTime = Duration();

  bool _isResending = false;
  Future _getNotification;

  resendMail(String email, String apiKey) async {
    setState(() {
      _isResending = true;
    });
    await http.post(
        'http://192.168.43.150/agrisen-api/index.php/Profile/resend_mail',
        body: {'email': email},
        headers: {'api_key': apiKey}).then((response) {
      final result = json.decode(response?.body?.toString());

      if (result == true) {
        setState(() {
          _isResending = false;
        });
        snakebar('The email has been send successfully check your inbox.');
      } else if (result == false) {
        setState(() {
          _isResending = false;
        });
        snakebar('The email could not be send check your internet connection');
      } else {
        setState(() {
          _isResending = false;
        });
        snakebar('User not Permitted');
      }
    }).catchError((onError) {
      setState(() {
        _isResending = false;
      });
      snakebar('something went wrong please try again later');
    });
  }

  snakebar(String message) {
    _globalKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Widget CustomListTile(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 7),
            child: CircleAvatar(
              maxRadius: 3,
              backgroundColor: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(title),
          )
        ],
      ),
    );
  }

  bool once = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (once) {
      final temp =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      if (temp.containsKey('verification')) {
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            final temp1 = DateTime.parse(temp['verification'])
                .add(Duration(days: 3))
                .difference(DateTime.now());
            setState(() {
              remainingTime = temp1;
            });
          } else {
            timer.cancel();
          }
        });
      } else if (temp.containsKey('notification')) {
        _getNotification = getNotification(temp['notification']['api_key'],
            temp['notification']['notification_id']);
      }
    }
    once = false;
  }

  getNotification(String apiKey, String notificationId) async {
    return await http.get(
        'http://192.168.43.150/agrisen-api/index.php/Profile/fetch_notification/$notificationId',
        headers: {
          'api_key': apiKey,
        });
  }

  Widget DetailsInfos({String label, String info, Color colors}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          info,
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
  void deactivate() async {
    super.deactivate();
    await Provider.of<LoadNotifications>(context, listen: false)
        .fetchNotificationDetails();
  }

  final _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final userinfos = Provider.of<UserInfos>(context).userInfos;

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Notification'),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
      ),
      body: !argument.containsKey('verification')
          ? FutureBuilder(
              future: _getNotification,
              builder:
                  (BuildContext buildContext, AsyncSnapshot<dynamic> snapshot) {
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
                      if (data.body != null) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              DetailsInfos(
                                label: 'Title : ',
                                info: argument['notification']['title'],
                                colors: Colors.green,
                              ),
                              DetailsInfos(
                                label: 'Send Date : ',
                                info: DateFormat.yMMMEd().add_jms().format(
                                    DateTime.parse(
                                        argument['notification']['time_send'])),
                                colors: Colors.red,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Full Notification',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Html(
                                  data: json.decode(data.body),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'By',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.asset(
                                  'assets/agrisen_logo_trans.png',
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      print('custom err: ${snapshot.error}');
                    }
                    return Text('Oop please check your internet connection!');
                  default:
                    return Container();
                }
              },
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Agrisen Thank you for being part of it community.',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomListTile(
                        'We invite you to look at your email and follow the link we send you for your email verification.'),
                    CustomListTile(
                        'Failing to do that will cause your account to be deleted completely after 3 days.'),
                    CustomListTile(
                        'If you did not receive any email after 24 hours? press the button below an a  new one will be resend.'),
                    CustomListTile(
                        'Your account will Expire on: ${DateFormat.yMMMEd().add_jms().format(DateTime.parse(argument['verification']).add(Duration(days: 3)))}'),
                    CustomListTile(
                        'Remaining: ${remainingTime.toString().split('.').first} ( - ${remainingTime.inDays} days ${remainingTime.inHours - (remainingTime.inDays * 24)} hours)'),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        padding: _isResending
                            ? EdgeInsets.symmetric(vertical: 8, horizontal: 4)
                            : EdgeInsets.only(),
                        label: _isResending
                            ? Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'sending...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Resend mail',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        disabledColor: Colors.black38,
                        color: Colors.green,
                        onPressed: !_isResending
                            ? (userinfos['email'] != null &&
                                    userinfos['api_key'] != null)
                                ? () => resendMail(
                                    userinfos['email'], userinfos['api_key'])
                                : null
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Thanks for your comprehension.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'By',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset(
                        'assets/agrisen_logo_trans.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
