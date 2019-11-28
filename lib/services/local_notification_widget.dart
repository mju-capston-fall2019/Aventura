import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:aventura/services/local_notications_helper.dart';
import 'package:aventura/test_page/second_page.dart';

class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage(payload: payload)),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            title('Basics'),
            RaisedButton(
              child: Text('알림보내기'),
              onPressed: () => showOngoingNotification(notifications,
                  title: 'Aventura', body: '콜로세움에 들어오셨습니다.'),
            ),
            RaisedButton(
              child: Text('logout'),
              onPressed: () => FirebaseAuth.instance.signOut(),
            )
          ],
        ),
      );

  Widget title(String text) => Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
      );
}
