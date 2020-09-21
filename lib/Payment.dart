import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Payment();
  }
}

class _Payment extends State<Payment> {
  bool _isChecked = false;

  TextEditingController _cardNumber = TextEditingController();
  TextEditingController _expDate = TextEditingController();
  TextEditingController _nameOnCard = TextEditingController();
  TextEditingController _cvv = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Credit/Debit Card",
            style: TextStyle(color: Colors.white),
          ),
          /*iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          )*/
        ),
        body: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 2.0),
                  ),
                  labelText: "Card Number",
                  hintText: "Card Number",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Colors.grey),
                  // labelStyle: TextStyle(color: Colors.black87),
                ),
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 2.0),
                  ),
                  labelText: "Expiry Date",
                  hintText: "DD-MM-YYYY",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black87, width: 2.0),
                  ),
                  labelText: "Name On Card",
                  hintText: "Name On Card",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                height: 20,
              ),
              Container(
                // padding: EdgeInsets.only(right: 100),
                width: 300,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(letterSpacing: 5),
                        autofocus: true,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 2.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 2.0),
                          ),
                          labelText: "CVV",
                          labelStyle: TextStyle(letterSpacing: 2),
                          hintText: "111",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.grey, letterSpacing: 5),
                        ),
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.only(bottom: 20, left: 10),
                    )
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value;
                      });
                    },
                  ),
                  Expanded(
                      child: Text(
                    "Keep my card details for future purchases",
                    style: TextStyle(fontSize: 12.0),
                  ))
                ],
              ),
              Container(
                height: 40,
                child: RaisedButton(
                  child: Text("Apply"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {},
                ),
              )
            ],
          ),
        ));
  }
}
