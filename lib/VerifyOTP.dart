import 'dart:convert';

import 'package:car_wash/Payment.dart';
import 'package:car_wash/Payments/Transactions.dart';
import 'package:car_wash/Payments/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Payments/server_stub.dart';
import 'Utils/UI.dart';

class VerifyOTP extends StatefulWidget {
  // String otp;
  String selectedId;
  String date;

  VerifyOTP(/*this.otp,*/ this.selectedId, this.date);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  Menifo menifo = Menifo();
  String url;
  String _selectedId;
  bool isLoading = false;
  TextEditingController optTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
    // optTextEditingController.text = widget.otp;
  }

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    url =
        menifo.getBaseUrl() + "OTPVerify?otp=${optTextEditingController.text}";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    // return jsonDecode(response.body);
    if (response.body == "x0") {

//       Fluttertoast.showToast(
//           msg: response.body,
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
// //                          timeInSecForIosWeb: 1,
//           backgroundColor: Colors.grey[600],
//           textColor: Colors.white,
//           fontSize: 16.0);
      final sessionId = await Server().createCheckout(_selectedId);
      print("Session Id:" +sessionId);
      Fluttertoast.showToast(
        msg: "Redirecting to Payment Gateway",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      final result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CheckoutPage(
            /*sessionId: sessionId,*/
            sessionId,
            _selectedId, widget.date),
      ));
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Result: $result'),
      //   ),
      // );
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => CheckoutPage()));
    } else {
      setState(() {
        isLoading = false;
      });
      return Fluttertoast.showToast(
        msg: "Invalid OTP",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Verification",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You will get a OTP via ",
                      style: TextStyle(fontSize: 16)),
                  Text(
                    "SMS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 160),
              Container(
                height: 80,
                margin: EdgeInsets.only(left: 40, right: 40),
                child: TextFormField(
                  validator: (value) {
                    Pattern pattern = r'^(\d{4})$';
                    RegExp regex = new RegExp(pattern);
                    if (value.isEmpty)
                      return "Please enter mobile number";
                    else if (!regex.hasMatch(value))
                      return "Invalid mobile number";
                    else
                      return null;
                  },
                  controller: optTextEditingController,
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 10, fontSize: 18),
                  autofocus: true,
                  showCursor: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintStyle: TextStyle(color: Colors.grey, letterSpacing: 10),
                      hintText: "0000"),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 40, right: 40),
                child: RaisedButton(
                  onPressed: isLoading == false
                      ? () {
                          if (optTextEditingController.text.length == 4) {
                            verifyOtp();
                          } else {
                            Fluttertoast.showToast(
                              msg: "Enter 4 Digits OTP",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey[600],
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }

//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => VerifyOTP()));
                        }
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: isLoading == false
                      ? Text("VERIFY")
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
