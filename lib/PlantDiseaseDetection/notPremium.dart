import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NotPremium extends StatefulWidget {
  @override
  _NotPremiumState createState() => _NotPremiumState();
}

class _NotPremiumState extends State<NotPremium> {
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handlePress;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  Widget _listTile(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: CircleAvatar(
              backgroundColor: Color.fromRGBO(10, 17, 40, 1.0),
              maxRadius: 3,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color.fromRGBO(10, 17, 40, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePress() async {
    HapticFeedback.heavyImpact();
    var dateFormat = DateFormat.yMMMd();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (builder) {
          return AlertDialog(
            title: Text(
              'Premium version',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                decoration: TextDecoration.underline,
              ),
            ),
            contentPadding: EdgeInsets.only(left: 10),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  _listTile(
                      'Solutions to any disease detected by our AI are available for you.'),
                  SizedBox(
                    height: 15,
                  ),
                  _listTile(
                      'You are assigned an online agriculture expart to help you with any problem you are facing.'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cost',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _listTile('5,000 FCFA per month'),
                  _listTile(
                      'i.e If you pay today on the : ${dateFormat.format(DateTime.now())}. Your pemium version will expire on the : ${dateFormat.format(DateTime.now().add(Duration(days: 31)))}.')
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Get the Premium version to have solutions to all the detected disease',
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red, //Color.fromRGBO(10, 17, 40, 1.0),
                fontSize: 18,
                wordSpacing: 3,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 70,
              width: 200,
              child: FlatButton(
                onPressed: () => null,
                child: Text(
                  'Buy Premium',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            RichText(
              maxLines: 2,
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'To view all the advantages offered by the',
                    style: TextStyle(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                    ),
                  ),
                  TextSpan(
                    text: ' Premium Version. ',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: 'Click here',
                    recognizer: _tapGestureRecognizer,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' and the Cost.',
                    style: TextStyle(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
