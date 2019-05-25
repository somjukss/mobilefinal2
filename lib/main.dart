import 'package:flutter/material.dart';
import 'package:mobilefinal2/screen/loginScreen.dart';
import 'package:mobilefinal2/screen/registerScreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PreTest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
        "/register": (context) => Register(),
        // "/profile": (context) => ProfilePage(),
        // "/friend": (context) => FriendPage(),
      },
    );
  }
}
