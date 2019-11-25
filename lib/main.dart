import 'package:aventura/data/join_or_login.dart';
import 'package:aventura/screens/login.dart';
import 'package:aventura/screens/RecommendationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aventura/services/local_notification_widget.dart';
import 'package:aventura/screens/memory_first_page.dart';
import 'package:aventura/screens/area_info_page.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MaterialApp(
    initialRoute: '/',
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => MyApp(),
      '/info': (context) => AreaInfo(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if(snapshot.data == null){
          return ChangeNotifierProvider<JoinOrLogin>.value(
          value: JoinOrLogin(),
          child: AuthPage());
        } else {
          return Container(
            child: PageView(
              children: <Widget>[
                MemoryFirstPage(),
                RecommendationScreen(),
                LocalNotificationWidget(),
              ],
              controller: PageController(initialPage: 1),
            ),
          );
        }
      }
    );
  }
}
