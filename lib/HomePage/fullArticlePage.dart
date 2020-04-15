import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

class FullArticlePage extends StatefulWidget {
  static const nameRoute = 'FullArticlePage';

  @override
  _FullArticlePageState createState() => _FullArticlePageState();
}

class _FullArticlePageState extends State<FullArticlePage> {
  FlutterTts flutterTts = FlutterTts();
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.4;
  bool playing = false;
  String title = '', des = '';

  void iniTts() {
    /*setState(() {
      _newVoiceText = 'Bonjour Jumper, comment tu vas ?';
    });*/
    flutterTts.setStartHandler(() {
      setState(() {
        print('start');
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print('complete');
        playing = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print('error: $msg');
      });
    });
  }

  Future _speak(String newVoiceText, String language) async {
    await flutterTts.setLanguage(language);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText != null) {
      if (newVoiceText.isNotEmpty) {
        final result = await flutterTts.speak(newVoiceText);
        if (result == 1) {
          setState(() {
            playing = true;
          });
        }
      }
    }
  }

  Future _stop() async {
    final result = await flutterTts.stop();
    if (result == 1) {
      setState(() {
        playing = false;
      });
    }
  }

  Future _articleData;

  _getArticle(int articleId) async {
    return await http.get(
        'http://192.168.43.150/agrisen-api/index.php/Home/fetch_articles/$articleId');
  }

  bool _once = true;

  @override
  void didChangeDependencies() {
    if (_once) {
      final articleData =
          ModalRoute.of(context).settings.arguments as List<dynamic>;
      setState(() {
        title = articleData[1];
        des = articleData[2];
      });
      _articleData = _getArticle(int.parse(articleData[0]));
    }
    _once = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    iniTts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    String speechText = 'No text available';

    speechText = speechText.replaceAll("\n", " ");
    //data = data.replaceAll(new RegExp(r''), "");

    print(speechText);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        actions: <Widget>[
          playing
              ? FlatButton.icon(
                  onPressed: () => _stop(),
                  icon: Icon(Icons.stop),
                  label: Text('stop'),
                )
              : FlatButton.icon(
                  onPressed: () => _speak(speechText, 'en-US'),
                  icon: Icon(Icons.play_arrow),
                  label: Text('play'),
                )
        ],
      ),
      body: FutureBuilder(
        future: _articleData,
        builder: (BuildContext buildContext, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return FullArticleSkeletonWidget();
            case ConnectionState.done:
              if (snapshot.hasData) {
                http.Response data = snapshot.data;
                final article = json.decode(data.body);
                speechText = article['article_text'];
                return CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            des,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Html(
                            data: article['article'],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                print('custom err: ${snapshot.error}');
              }
              return Center(
                child: Text('No data available yet'),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class FullArticleSkeletonWidget extends StatefulWidget {
  @override
  _FullArticleSkeletonWidgetState createState() =>
      _FullArticleSkeletonWidgetState();
}

class _FullArticleSkeletonWidgetState extends State<FullArticleSkeletonWidget> {
  @override
  void initState() {
    // TODO: implement initState
    startAnimation();
    super.initState();
  }

  bool _animateOpacity = true, val = true;

  startAnimation() {
    Timer.periodic(Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _animateOpacity = !_animateOpacity;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Widget text(EdgeInsetsGeometry margin) {
    return Container(
      height: 15,
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _animateOpacity ? (val ? 0.2 : 0.8) : (val ? 0.8 : 0.2),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.symmetric(horizontal: width * 0.1)),
              SizedBox(
                height: 5,
              ),
              text(EdgeInsets.symmetric(horizontal: width * 0.25)),
              SizedBox(
                height: 20,
              ),
              text(EdgeInsets.only(right: width * 0.05)),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only(right: width * 0.15)),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only(right: width * 0.25)),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black12,
              ),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only()),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only()),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only(right: width * 0.05)),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only(right: width * 0.15)),
              SizedBox(
                height: 10,
              ),
              text(EdgeInsets.only(right: width * 0.25)),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black12,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
