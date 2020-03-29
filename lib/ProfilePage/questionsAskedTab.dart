import 'dart:convert';

import 'package:agrisen_app/Community/AskCommunity/askCommunityForm.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../imagesViewer.dart';

class QuestionsAskedTab extends StatefulWidget {
  final String apiKey;
  QuestionsAskedTab({@required this.apiKey});

  @override
  _QuestionsAskedTabState createState() => _QuestionsAskedTabState();
}

class _QuestionsAskedTabState extends State<QuestionsAskedTab>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  double _value = 0.0;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    Animation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.bounceOut);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        print(_value);
        setState(() {
          _value = _animation.value;
        });
      });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helps =
        Provider.of<LoadHelps>(context).getAllYourAskHelps(widget.apiKey);
    print(widget.apiKey);
    return helps.isNotEmpty
        ? Column(
            children: <Widget>[
              ...helps.map((help) {
                final index = helps.indexOf(help);
                final images = json.decode(help['crop_images']);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      if (index == 0)
                        Column(
                          children: <Widget>[
                            Text(
                              helps != []
                                  ? '${helps[0]['user_name']} below is the list of the helps you asked the Community'
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ListTile(
                        leading: InkWell(
                          onTap: () => Navigator.of(context).pushNamed(
                              ImagesViewer.namedRoute,
                              arguments: {'from': 'network', 'images': images}),
                          child: Image.network(
                            'http://192.168.43.150/Agrisen_app/AgrisenMobileAppAPIs/AskHelpImages/${images[0]}',
                            fit: BoxFit.cover,
                            width: 90,
                          ),
                        ),
                        title: Text(
                          help['question'].endsWith('?')
                              ? help['question']
                              : '${help['question']} ?',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(help['crop_name']),
                        trailing: FittedBox(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => null,
                              ),
                              Text(
                                'delete',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              }).toList()
            ],
          )
        : Opacity(
            opacity: _value,
            child: Center(
              child: SizedBox(
                height: 50,
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.help_outline,
                    color: Color.fromRGBO(10, 17, 40, 1.0),
                  ),
                  splashColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  label: Text(
                    'Ask Help To Community',
                    style: TextStyle(
                      color: Color.fromRGBO(10, 17, 40, 1.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AskCommunityForm.routeName,
                      arguments: {'api-key': widget.apiKey},
                    );
                  },
                ),
              ),
            ),
          );
  }
}
