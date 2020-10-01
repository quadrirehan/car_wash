import 'dart:convert';

import 'package:car_wash/AddressPicker.dart';
import 'package:car_wash/OrderDetails.dart';
import 'package:car_wash/Users/LogIn.dart';
import 'package:car_wash/Utils/DatabaseHelper.dart';
import 'package:car_wash/Utils/UI.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllBookings extends StatefulWidget {
  @override
  _AllBookingsState createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {
  String url;
  Menifo menifo;
  String userId;
  String userName;
  String userMobile;
  int delay = 0;

  Future<List> futureAllBookings;

  @override
  void initState() {
    super.initState();
    menifo = Menifo();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List user = await db.getUser();
    setState(() {
      userId = user[0]['user_id'].toString();
      userName = user[0]['user_name'].toString();
      userMobile = user[0]['user_mobile'].toString();
    });
    print(userId);
    setState(() {
      futureAllBookings = _getBookings();
    });
  }

  Future<List> _getBookings() async {
    url = menifo.getBaseUrl() + "OrdersReport?customer_id=$userId";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "Application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Bookings"),
        actions: <Widget>[
          InkWell(onTap: (){
            setState(() {
              delay = 1;
            });
           reloadAllBookings();
            setState(() {
              futureAllBookings = _getBookings();
            });
          },
              child: Icon(Icons.refresh, color: Colors.white)),
          PopupMenuButton<String>(
            onSelected: _selected,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: delay == 0 ? Padding(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        child: FutureBuilder(
            future: futureAllBookings,
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data.toString() == "[]") {
                  return Center(child: Text("No Previous Bookings"));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snap.data.length != 0 ? snap.data.length : 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderDetails(
                                        userName,
                                        userMobile,
                                        snap.data[index]['order_id'].toString(),
                                        userId)));
                          },
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                                leading: Text(snap.data[index]['booking_date']
                                    .toString()
                                    .split(" ")[0]),
                                title: Text(
                                  "Package: " +
                                              snap.data[index]['package_id']
                                                  .toString() ==
                                          "1"
                                      ? "Premium Wash"
                                      : snap.data[index]['package_id']
                                                  .toString() ==
                                              "2"
                                          ? "Standard Wash"
                                          : "Regular Wash",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(snap.data[index]
                                        ['appointment_date']
                                    .toString()
                                    .split(" ")[0]),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Order Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    snap.data[index]['order_status']
                                                .toString() ==
                                            "0"
                                        ? Text("Pending")
                                        : snap.data[index]['order_status']
                                                    .toString() ==
                                                "1"
                                            ? Text("Completed",
                                                style: TextStyle(
                                                    color: Colors.green))
                                            : Text(
                                                "Cancelled",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                  ],
                                )),
                          ),
                        );
                      });
                }
              } else if (snap.hasError) {
                return Center(
                  child: Text("Try Again"),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ) : Center(child: CircularProgressIndicator(),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddressPicker()));
        },
        child: Icon(Icons.add),
        tooltip: "Book Your Car Wash",
      ),
    );
  }

  void _selected(String value) {
    switch (value) {
      case 'Logout':
        DatabaseHelper db = DatabaseHelper.instance;
        db.deleteUser().whenComplete(() => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LogIn()))
            });
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LogIn()));
        // print("Logout");
        break;
    }
  }

  void reloadAllBookings(){
    Future.delayed(Duration(seconds: 2), (){
      setState(() {
        delay = 0;
      });
    });
  }
}
