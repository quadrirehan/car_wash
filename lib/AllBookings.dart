import 'dart:convert';

import 'package:car_wash/AddressPicker.dart';
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

  @override
  void initState() {
    super.initState();
    menifo = Menifo();
    getUserId();
  }

  Future<void> getUserId() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List user = await db.getUser();
    setState(() {
      userId = user[0]['user_id'];
    });
    print(userId);
  }

  Future<List> _getBookings() async {
    url = menifo.getBaseUrl() + "OrdersReport?customer_id=$userId";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "Application/json"});
    // print(response.body);
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: FutureBuilder(
              future: _getBookings(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data == null) {
                    return Center(child: Text("No Data Found"));
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data.length != 0 ? snap.data.length : 0,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Text(snap.data[index]['booking_date'].toString().split(" ")[0]),
                              title: Text("Package: " +
                                snap.data[index]['package_id'] == "1"
                                    ? "Premium Wash"
                                    : snap.data[index]['package_id'] == "2"
                                        ? "Standard Wash"
                                        : "Regular Wash",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(snap.data[index]['appointment_date'].toString().split(" ")[0]),
                              trailing: snap.data[index]['payment_status'] == "1"
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
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
        ),
      ),
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
}
