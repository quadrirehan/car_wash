import 'package:car_wash/AllBookings.dart';
import 'package:flutter/material.dart';
import 'Users/LogIn.dart';
import 'Utils/DatabaseHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DatabaseHelper db = DatabaseHelper.instance;
  int userCount;

  @override
  Future<void> initState() {
    super.initState();
   Future.delayed(Duration(seconds: 3), () async {
     userCount = await db.getCount();
      if (userCount > 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AllBookings()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LogIn()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "CAR WASH",
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.blue),
      )),
    );
  }
}
