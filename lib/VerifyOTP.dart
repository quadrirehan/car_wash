import 'package:car_wash/Payments/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'AllBookings.dart';
import 'Payments/server_stub.dart';
import 'Utils/DatabaseHelper.dart';
import 'Utils/UI.dart';

class VerifyOTP extends StatefulWidget {
  // String otp;
  String selectedId;
  String date;
  String time;
  double lat;
  double lng;
  String carDetails;
  String paymentType;

  VerifyOTP(/*this.otp,*/ this.selectedId, this.date, this.time, this.lat,
      this.lng, this.carDetails, this.paymentType);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  Menifo menifo = Menifo();
  String url;
  String _selectedId;
  String userId;
  bool isLoading = false;
  TextEditingController optTextEditingController = TextEditingController();

  Future<void> getUserId() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List user = await db.getUser();
    setState(() {
      userId = user[0]['user_id'];
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
    // optTextEditingController.text = widget.otp;
    getUserId();
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
      /*if (widget.paymentType.toString() == "2") {
        if(userId != null){
          url = menifo.getBaseUrl() +
              "OrderCreate?customer_id=$userId&appointment_date=${widget.date}&appointment_time=${widget.time}&package_id=${widget.selectedId}&payment_status=0&customer_lat=${widget.lat}&customer_long=${widget.lng}&customer_car=${widget.carDetails}&payment_type=${widget.paymentType}";
          var response = await http
              .get(Uri.encodeFull(url), headers: {'Accept': "application/json"}).then((value) {
                print("Value: ::: : ${value.body.toString()}");
            Alert(
                context: context,
                type: AlertType.success,
                title: "Success",
                // content: InkWell(child: Text("OK"), onTap: (){Navigator.pop(context);},),
                style: AlertStyle(
                  isOverlayTapDismiss: false,
                ),
                buttons: [
                  DialogButton(
                      radius: BorderRadius.circular(10),
                      child: Text("Close", style: TextStyle(color: Colors.white),),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => AllBookings()));
                      })
                ],
                closeFunction: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AllBookings()));
                }).show();
          });
          print(response.body.toString());

        }else{
          setState(() {
            isLoading = false;
          });
          print("User Id: ::: : $userId");
        }

      }*/
      // else {
        final sessionId = await Server().createCheckout(_selectedId);
        print("Session Id:" + sessionId);
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
              _selectedId,
              widget.date,
              widget.time,
              widget.lat,
              widget.lng,
              widget.carDetails,
              widget.paymentType),
        ));
      // }
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
              SizedBox(height: 125),
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
                      hintStyle:
                          TextStyle(color: Colors.grey, letterSpacing: 10),
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
