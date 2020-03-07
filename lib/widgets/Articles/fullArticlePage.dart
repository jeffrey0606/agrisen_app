
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import 'package:agrisen_app/Providers/loadArticles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

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
    final articleId = ModalRoute.of(context).settings.arguments as String;
    final articleData = Provider.of<LoadArticles>(context).getArticle(articleId);

    String data = articleData['article_text'];

    
    data = data.replaceAll("\n", " ");
    //data = data.replaceAll(new RegExp(r''), "");

    print(data);

    return Scaffold(
      appBar: AppBar(
        title: Text(articleData['crop_name']),
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
                  onPressed: () => _speak(data, 'en-US'),
                  icon: Icon(Icons.play_arrow),
                  label: Text('play'),
                )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Hero(
          tag: articleId,
          child:
              /*FadeInImage(
            placeholder: AssetImage('assets/testImage1.png'),
            image: NetworkImage(
              articleData.leadingImage,
            ),
            fit: BoxFit.cover,
          ),*/
              SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Html(
                data: articleData['article'],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
