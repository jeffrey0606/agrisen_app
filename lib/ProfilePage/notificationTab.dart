import 'package:agrisen_app/ProfilePage/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTab extends StatefulWidget {
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  var dateTime = DateFormat('yMd').add_jms();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () =>
                Navigator.of(context).pushNamed(Notifications.nameRoute),
            leading: CircleAvatar(
              maxRadius: 30,
            ),
            title: Text(
              'Message :',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
              'from :',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        },
      ),
    );
  }
}