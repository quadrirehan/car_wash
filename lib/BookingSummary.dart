import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'MobileNoVerify.dart';

class BookingSummary extends StatefulWidget {
  String date;
  String time;
  String address;
  String package;
  String packageDuration;
  String packagePrice;
  String selectedId;

  BookingSummary(this.date, this.time, this.address, this.package, this.packageDuration, this.packagePrice, this.selectedId);

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  String _date = "Select Date";
  String _time = "Select Time";
  String _address;
  String _package;
  String _packageDuration;
  String _packagePrice;
  String _selectedId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _date = widget.date;
      _time = widget.time;
      _address = widget.address;
      _package = widget.package;
      _packageDuration = widget.packageDuration;
      _packagePrice = widget.packagePrice;
      _selectedId = widget.selectedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Text(
                      "Booking Overview",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Row(
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
                                          color: Colors.white,
                                          fontSize: 16,
                                          /*color: Colors.white,*/
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
                                      _time =
                                          "$time".split(" ")[1].substring(0, 8);
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
                                          color: Colors.white,
                                          fontSize: 16,
                                          /*color: Colors.white,*/
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Text(
                              _address,
                              style: TextStyle(
                                  /*fontSize: 18*/),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: Colors.grey,
                            size: 30,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter CAR Details..."
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      _package + " wash",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(_packageDuration,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Text("$_packagePrice £",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Refill windshield liquid",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text("3 £",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Hard wax",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text("15 £",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green[300]),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "TOTAL",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text( "${double.parse(_packagePrice)+3+15} £",
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      child: RaisedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MobileNoVerify(_selectedId, _date,)));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Confirm Booking",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          color: Colors.blue),
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
