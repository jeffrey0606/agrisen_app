import 'dart:convert';
import 'dart:io';
import 'package:agrisen_app/Providers/loadCommentedHelps.dart';
import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:agrisen_app/Providers/loadHelps.dart';
import 'package:agrisen_app/timeAjuster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'askCommunityCard.dart';
import '../CommentingPage/commentingPage.dart';



class QuestionsAsked extends StatefulWidget {
  static String nameRoute = 'AskExpert';

  @override _QuestionsAskedState createState() => _QuestionsAskedState();
}

class _QuestionsAskedState extends State<QuestionsAsked> {

  bool once = true;
  String api_key = '';

  @override
  void didChangeDependencies() async{
    if(once){
      await Provider.of<LoadHelps>(context).fetchHelps();
      await Provider.of<LoadComments>(context, listen: false).fechComments();
      final sharedPref = await SharedPreferences.getInstance();

      if (sharedPref.containsKey('userInfos')) {
        final userinfos = json.decode(sharedPref.getString('userInfos'));
        _fechCommentedHelps(userinfos['api-key']);
        setState(() {
          api_key = userinfos['api-key'];
        });
      }
    }
    once = false;
    super.didChangeDependencies();
  }

  void _fechCommentedHelps(String apiKey) async {
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechCommentedHelps(apiKey);
    await Provider.of<LoadCommentedHelps>(context, listen: false)
        .fechNotYetViewedComments(apiKey);
  }

  @override
  Widget build(BuildContext context) {
    final loadhelps = Provider.of<LoadHelps>(context);
    final helpsData = loadhelps.getHelpsData;
    return Scrollbar(
      child: ListView.builder(
        itemCount: helpsData.length,
        itemBuilder: (buildContext, index) {
          return Container(
            child: AskCommunityCard(
              cropName: helpsData[index]['crop_name'],
              profileImage: helpsData[index]['profile_image'],
              cropImage: json.decode(helpsData[index]['crop_images'])[0],
              question: helpsData[index]['question'],
              timelapse: TimeAjuster.ajust(DateTime.parse(helpsData[index]['timestamp'])),
              userName: helpsData[index]['user_name'],
              askHelpId: helpsData[index]['askHelp_id'],
              onTap: (){
                Navigator.pushNamed(context, CommentingPage.routeName, arguments: helpsData[index]['askHelp_id']);
              },
            ),
          );
        },
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Ask',
          style: TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(10, 17, 40, 1.0),
          ),
        ),
        icon: Icon(
          Icons.edit,
          size: 30,
          color: Color.fromRGBO(10, 17, 40, 1.0),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => AskCommunityForm(),
          ),
        ),
      ),*/
    );
  }
}
