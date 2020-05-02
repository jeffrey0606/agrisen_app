import 'dart:convert';
import 'dart:io';

import 'package:agrisen_app/Providers/loadComments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class AskCommunityCard extends StatefulWidget {
  final String cropName;
  final String question;
  final String userName;
  final String profileImage;
  final String timelapse;
  final Function onTap;
  final String cropImage;
  final String askHelpId;

  AskCommunityCard({
    this.onTap,
    this.cropName,
    this.question,
    this.userName,
    this.profileImage,
    this.timelapse,
    this.cropImage,
    this.askHelpId,
  });

  @override
  _AskCommunityCardState createState() => _AskCommunityCardState();
}

class _AskCommunityCardState extends State<AskCommunityCard> {
  bool once = true;
  int commentsNumber = 0;

  @override
  void didChangeDependencies() async {
    if (once) {
      await getCommentsNumber(widget.askHelpId);
    }
    once = false;
    super.didChangeDependencies();
  }

   Future getCommentsNumber(String askHelpId) async{
    try {
      final response = await http.get('http://192.168.43.150/agrisen-api/index.php/Community/number_of_comments/$askHelpId');
      if(response != null){
        setState(() {
          commentsNumber = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var nameInitials = '';
    widget.userName.split(' ').forEach((f) {
      setState(() {
        if (nameInitials.length == 1) {
          nameInitials += ' ';
        }
        nameInitials += '${f.substring(0, 1)}';
      });
    });
    return Container(
      margin: EdgeInsets.only(top: 5.0, left: 0, right: 0, bottom: 5),
      child: Card(
        child: InkWell(
          onTap: () => widget.onTap(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 340,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.network(
                      'http://192.168.43.150/agrisen-api/uploads/ask_helps/${widget.cropImage}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                ),
                                child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          //Colors.lime,
                                          //Colors.pink,
                                          Colors.cyan,
                                          Colors.cyanAccent
                                        ]),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(60),
                                    ),
                                  ),
                                  child: widget.profileImage.toString().isEmpty
                                      ? Center(
                                          child: Text(
                                            nameInitials.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                          imageUrl: widget.profileImage
                                                  .toString()
                                                  .startsWith('https://')
                                              ? widget.profileImage
                                              : 'http://192.168.43.150/agrisen-api/uploads/profile_images/${widget.profileImage}',
                                          errorWidget: (context, str, obj) {
                                            return Center(
                                              child: Text(
                                                nameInitials.toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          },
                                          /*placeholder: (context, str) {
                                            return SvgPicture.network(
                                              'http://192.168.43.150/Agrisen_app/assetImages/profileImage.svg',
                                              width: 115,
                                            );
                                          },*/
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    this.widget.userName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    this.widget.timelapse,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            this.widget.question.endsWith('?')
                                ? this.widget.question
                                : '${this.widget.question} ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  this.widget.cropName,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(3),
                                        constraints: BoxConstraints(
                                          minWidth: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            commentsNumber.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Comments',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
