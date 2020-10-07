import 'dart:convert';
import 'package:car_wash/AllBookings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Utils/UI.dart';
import 'package:maps_launcher/maps_launcher.dart';

class OrderDetails extends StatefulWidget {
  String _customerName;
  String _customerMobile;
  String _orderId;
  String _userId;

  OrderDetails(
      this._customerName, this._customerMobile, this._orderId, this._userId);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String url;
  Menifo menifo;
  String address = "";
  var orderDetails;
  String orderStatus;

  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menifo = Menifo();
    getOrderDetails();
  }

  void getOrderDetails() async {
    url = menifo.getBaseUrl() + "OrdersDetails?order_id=${widget._orderId}";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "Application/json"});
    orderDetails = await json.decode(response.body.toString());
    print(widget._orderId+" :: Status :: "+orderDetails[0]['order_status'].toString());
    // print("Latitude: " + orderDetails[0]['customer_lat']);
    getAddress(orderDetails[0]['customer_lat'].toString(),
        orderDetails[0]['customer_long'].toString());
    setState(() {
      orderStatus = orderDetails[0]['order_status'].toString();
    });
  }

  Future<void> cancelOrder() async {
    url = menifo.getBaseUrl() +
        "UserCancelOrder?order_id=${widget._orderId}&customer_id=${widget._userId}";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "Application/json"});
    if (response.body.toString() == "Order Canceled") {
      print(widget._userId);
      print(widget._orderId);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AllBookings()));
      Fluttertoast.showToast(
          msg: response.body.toString(),
          backgroundColor: Colors.grey[600],
          fontSize: 16.0,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    } else {
      print(widget._userId);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Error While Canceling Order",
          backgroundColor: Colors.grey[600],
          fontSize: 16.0,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        centerTitle: true,
      ),
      body: orderDetails != null
          ? Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, right: 8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "User Name",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Text(widget._customerName))
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Mobile No.",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(child: Text(widget._customerMobile))
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Package",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        orderDetails[0]['package_id'].toString() == "1"
                            ? "Premium Wash"
                            : orderDetails[0]['package_id'].toString() == "2"
                                ? "Standard Wash"
                                : "Regular Wash",
                      ))
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Car Details",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child:
                              Text(orderDetails[0]['customer_car'].toString()))
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Payment Mode",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          orderDetails[0]['payment_type'].toString() == "1"
                              ? "Prepaid"
                              : "COD",
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Date & Time",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(orderDetails[0]['appointment_date']
                                  .toString() +
                              " " +
                              orderDetails[0]['appointment_time'].toString()))
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        width: 115,
                        child: Row(
                          children: [
                            Text(
                              "Address",
                              style: _textStyle,
                            ),
                            Expanded(
                              child: Text(
                                ":",
                                textAlign: TextAlign.right,
                                style: _textStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                          ),
                          InkWell(
                              onTap: () {
                                MapsLauncher.launchCoordinates(
                                    double.parse(
                                        orderDetails[0]['customer_lat']),
                                    double.parse(
                                        orderDetails[0]['customer_long']));
                              },
                              child: Text(
                                "View On Map",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      ))
                    ],
                  ),
                  /*SizedBox(height: 40),
                  orderStatus.toString() == "0" ? Container(
                    height: 40,
                    child: RaisedButton(
                      onPressed: () {
                        Alert(
                          context: context,
                          title: "Are you sure, you want to cancel this Order",
                          style: AlertStyle(isCloseButton: false, isOverlayTapDismiss: false),
                          type: AlertType.warning,
                          buttons: [
                            DialogButton(
                                child: Text("Cancel", style: TextStyle(color: Colors.white),),
                                onPressed: () {
                                  Navigator.pop(context);
                                }, ),
                            DialogButton(
                                child: Text("Confirm", style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  cancelOrder();
                                })
                          ],
                          closeFunction: (){
                            Navigator.pop(context);
                          }
                        ).show();
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text("Cancel Order"),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ) : Container()*/
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void getAddress(String lat, String lon) async {
    var addresses;
    var first;
    final coordinates = new Coordinates(double.parse(lat), double.parse(lon));
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;

    setState(() {
      address = first.addressLine.toString().replaceAll("'", "");
    });
    print("address: " + address);
    // return Text(address);
  }
}
