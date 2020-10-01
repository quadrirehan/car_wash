import 'package:car_wash/Utils/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'Utils/UI.dart';
import 'VerifyOTP.dart';

class MobileNoVerify extends StatefulWidget {
  String selectedId;
  String date;
  String time;
  double lat;
  double lng;
  String carDetails;
  String paymentType;


  MobileNoVerify(this.selectedId, this.date, this.time, this.lat, this.lng, this.carDetails, this.paymentType);

  @override
  _MobileNoVerifyState createState() => _MobileNoVerifyState();
}

class _MobileNoVerifyState extends State<MobileNoVerify> {
  Menifo menifo = Menifo();
  String url;
  String _selectedId;
  bool isLoading = false;

  TextEditingController mobileNo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
    getMobileNo();
  }

  Future<void> getMobileNo() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List user = await db.getUser();
    // print(user[0]['user_mobile']);
    mobileNo.text = user[0]['user_mobile'];
  }

  Future<void> getOtp() async {
    setState(() {
      isLoading = true;
    });
    url = menifo.getBaseUrl() + "OtpGenerate?mobile=${mobileNo.text}";
    print(url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    // print(response.body);
    if(response.body.toString() == "x1"){
      setState(() {
        isLoading = false;
      });
      return Fluttertoast.showToast(
        msg: "Invalid Mobile Number",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }else{
      setState(() {
        isLoading = false;
      });
      print("OTP Generate: "+response.body.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyOTP(_selectedId, widget.date, widget.time, widget.lat, widget.lng, widget.carDetails, widget.paymentType)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
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
                    Text(
                      "We will send you a ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "One Time Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "on your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 115),
                Container(
                  height: 80,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    controller: mobileNo,
                    autofocus: true,
                    showCursor: false,
                    textAlign: TextAlign.center,
                    maxLength: 10,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      prefixText: "+44",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter Registered Phone Number"),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: isLoading == false ? () {
                      if (mobileNo.text.length == 10) {
                        getOtp();
                      } else {
                        Fluttertoast.showToast(
                          msg: "Enter 10 Digits Mobile Number",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.grey[600],
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    } : null,
                    child: isLoading == false ?
                    Text("GET OTP") :
                    Center(child: CircularProgressIndicator(),),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
