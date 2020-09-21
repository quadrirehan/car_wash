import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'BookingSummary.dart';
import 'Utils/UI.dart';

class WashingPackage extends StatefulWidget {
  String address;

  WashingPackage(this.address);

  @override
  _WashingPackageState createState() => _WashingPackageState();
}

class _WashingPackageState extends State<WashingPackage> {
  Menifo menifo = Menifo();
  String url;
  Color colour = Colors.blue;

  String _date = "Select Date";
  String _time = "Select Time";

  String selectedId;
  String packagePrice;
  String _package = "";
  String packageDuration;

  @override
  void initState() {
    super.initState();
  }

  Future<List> getPackages() async {
    url = menifo.getBaseUrl() + "Packages";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    return jsonDecode(response.body);
  }

  Future<List> getPackageItems() async {
    url = menifo.getBaseUrl() + "PackageItems";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          DatePicker.showDatePicker(context,
                              onConfirm: (date) {
                                setState(() {
                                  _date = "$date".split(" ")[0];
                                });
                              });
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.date_range,
                                  size: 30, color: Colors.white),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  _date,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          DatePicker.showTimePicker(context,
                              onConfirm: (time) {
                                setState(() {
                                  _time = "$time".split(" ")[1].substring(0, 8);
                                });
                              });
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time,
                                  size: 30, color: Colors.white),
                              SizedBox(
                                height: 10,
                              ),
                              Text(_time,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 120,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Text(
                      "Only Home Services Awesome Feature !",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      "Complete car cleaning.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      "Save time. Save money. Door step service.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              FutureBuilder(
                future: getPackages(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    if (snap.data != null) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              snap.data.length != 0 ? snap.data.length : 0,
                          itemBuilder: (context, index) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedId =
                                          snap.data[index]['package_id'].toString();
                                      print(snap.data[index]['package_id']);
                                      packagePrice =
                                          snap.data[index]['package_price'].toString();
                                      _package =
                                          snap.data[index]['package_name'];
                                      packageDuration =
                                          snap.data[index]['package_duration'];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: selectedId ==
                                              snap.data[index]['package_id']
                                          ? colour
                                          : Colors.white,
                                    ),
                                    height: 60,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          snap.data[index]['package_name'],
                                          style: TextStyle(
                                              color: selectedId ==
                                                      snap.data[index]
                                                          ['package_id']
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                        Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey),
                                            child: Center(
                                              child: Text(
                                                  snap.data[index]
                                                      ['package_duration'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          height: 20,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.teal),
                                          child: Center(
                                            child: Text(
                                                "${snap.data[index]['package_price']} £",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            );
                          });
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Center(child: Text("No Data Found")),
                      );
                    }
                  } else if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(child: Text("Try Again Later")),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              Container(
                  padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black),
                  child: FutureBuilder(
                    future: getPackageItems(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        if (snap.data != null) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  snap.data.length != 0 ? snap.data.length : 0,
                              itemBuilder: (context, index) {
                                return ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          snap.data[index]['item_name'],
                                          style: TextStyle(color: Colors.white),
                                        )),
                                        Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              });
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Center(
                                child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white),
                            )),
                          );
                        }
                      } else if (snap.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                              child: Text(
                            "Try Again Later",
                            style: TextStyle(color: Colors.white),
                          )),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  )),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green[300]),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      "$packagePrice £",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                      child: Container(
                        height: 40,
                        child: RaisedButton(
                          onPressed: () {
                            // print(selectedId!=null);
                            if (selectedId != null && _date != "Select Date" && _time != "Select Time") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingSummary(
                                          _date,
                                          _time,
                                          widget.address,
                                          _package,
                                          packageDuration,
                                          packagePrice,
                                      selectedId)));
                            }
                            // else if(selectedId != null && _date == "Select Date" && _time != "Select Time"){
                            //   Fluttertoast.showToast(
                            //       msg: "Select Date !",
                            //       backgroundColor: Colors.grey,
                            //       textColor: Colors.white,
                            //       gravity: ToastGravity.BOTTOM,
                            //       toastLength: Toast.LENGTH_LONG,
                            //       fontSize: 16.0
                            //   );
                            // }
                            // else if(selectedId != null && _date != "Select Date" && _time == "Select Time"){
                            //   Fluttertoast.showToast(
                            //       msg: "Select Time !",
                            //       backgroundColor: Colors.grey,
                            //       textColor: Colors.white,
                            //       gravity: ToastGravity.BOTTOM,
                            //       toastLength: Toast.LENGTH_LONG,
                            //       fontSize: 16.0
                            //   );
                            // }
                            else if(selectedId == null && _date != "Select Date" && _time != "Select Time"){
                              Fluttertoast.showToast(
                                msg: "Select Your Package First !",
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG,
                                fontSize: 16.0
                              );
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Select Date, Time and Package !",
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG,
                                  fontSize: 16.0
                              );
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: colour,
                          child: Text("Continue"),
                          textColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
