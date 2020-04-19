import 'package:agrisen_app/ProfilePage/notifications.dart';
import 'package:agrisen_app/Providers/loadNotification.dart';
import 'package:agrisen_app/Providers/userInfos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationTab extends StatefulWidget {
  final String apiKey;
  NotificationTab({@required this.apiKey});
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  var dateTime = DateFormat('yMd').add_jms();

  @override
  Widget build(BuildContext context) {
    final _isVerified =
        Provider.of<UserInfos>(context).userInfos['verification'];
    final notif = Provider.of<LoadNotifications>(context);
    final notificationDetails = notif.notifications;
    final viewedNotifications = notif.viewedNotifications;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 15,
        ),
        itemCount: notificationDetails.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              if (index == 0 && _isVerified != null)
                Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                          Notifications.nameRoute,
                          arguments: {'verification': _isVerified}),
                      leading: CircleAvatar(
                        maxRadius: 30,
                      ),
                      title: Text(
                        'Title : User Authentication',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        'from : Agrisen Team',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: FittedBox(
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          minRadius: 5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ListTile(
                onTap: () => Navigator.of(context).pushNamed(
                  Notifications.nameRoute,
                  arguments: {
                    'notification': {
                      'title': notificationDetails[index]['about'],
                      'notification_id': notificationDetails[index]['notification_id'],
                      'api_key': widget.apiKey,
                      'time_send': notificationDetails[index]['time_send']
                    },
                  },
                ),
                leading: CircleAvatar(
                  maxRadius: 30,
                ),
                title: Text(
                  'Title : ${notificationDetails[index]['about']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                subtitle: Text(
                  'from : Agrisen Team',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                trailing: SizedBox(
                  height: 30,
                  width: 40,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(3),
                      constraints: BoxConstraints(
                        minWidth: 30,
                      ),
                      decoration: BoxDecoration(
                        color: viewedNotifications.any((test) =>
                                test['notification_id'] ==
                                notificationDetails[index]['notification_id'])
                            ? Colors.grey
                            : Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          viewedNotifications.any((test) =>
                                  test['notification_id'] ==
                                  notificationDetails[index]['notification_id'])
                              ? 'SEEN'
                              : 'NEW',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
