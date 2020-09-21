import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../AddressPicker.dart';
import 'package:http/http.dart' as http;

import 'LogIn.dart';
import '../Utils/UI.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Menifo menifo = Menifo();
  String url;
  bool isSignIn = false;

  final _formKey = GlobalKey<FormState>();
  Color colour = Colors.blue;

  TextEditingController _fName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobileNo = TextEditingController();
  TextEditingController _pass = TextEditingController();

  Future<void> _registerUser() async {
    setState(() {
      isSignIn = true;
    });

    url = menifo.getBaseUrl() +
        "UserRegister?user_name=${_fName.text}&user_email=${_email.text}&user_mobile=${_mobileNo.text}&user_password=${_pass.text}";
    print("URL: " + url);
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});

    if (response.body == "User Registered Successfully") {
      setState(() {
        isSignIn = false;
      });
      Navigator.pop(context);
      return Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
//      timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        isSignIn = false;
      });
      return Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
//      timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25, color: colour),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "FULL NAME : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    controller: _fName,
                    // validator: (value){
                    //   if(value.isEmpty){
                    //     return "Please Enter Full Name";
                    //   }
                    //   else{
                    //     return null;
                    //   }
                    // },
                    decoration: InputDecoration(
                        hintText: "Enter Your Full Name Here",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "EMAIL : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    controller: _email,
                    // validator: (value) {
                    //   if (EmailValidator.validate(value)) {
                    //     return null;
                    //   } else if (value.isEmpty) {
                    //     return "Please enter email address";
                    //   } else
                    //     return "Invalid email address";
                    // },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "MOBILE NO : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    controller: _mobileNo,
                    // validator: (value) {
                    //   Pattern pattern = r'^(\d{10})$';
                    //   RegExp regex = new RegExp(pattern);
                    //   if (value.isEmpty)
                    //     return "Please enter mobile number";
                    //   else if(!regex.hasMatch(value))
                    //     return "Invalid mobile number";
                    //   else
                    //     return null;
                    // },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: "Enter Mobile No.",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "PASSWORD ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(40)),
                  child: TextFormField(
                    controller: _pass,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                Container(
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    onPressed: isSignIn == false
                        ? () {
                            if (_fName.text.isNotEmpty &&
                                _email.text.isNotEmpty &&
                                _mobileNo.text.isNotEmpty &&
                                _pass.text.isNotEmpty) {
                              _registerUser();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Enter All Details",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
//      timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey[600],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            // if(_formKey.currentState.validate()){
                            //
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => AddressPicker()));
                            // }
                          }
                        : null,
                    color: colour,
                    textColor: Colors.white,
                    child: isSignIn == false
                        ? Text("SignUp")
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "By Sign up, you agree our ",
                      style: TextStyle(fontSize: 13),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Text(
                        "Terms and Conditions.",
                        style: TextStyle(
                            color: colour,
                            fontSize: 13,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an account? ",
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Text(
                        "LogIn",
                        style: TextStyle(
                            color: colour,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
