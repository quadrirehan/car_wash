import 'dart:convert';
import 'package:car_wash/AllBookings.dart';
import 'package:car_wash/Utils/DatabaseHelper.dart';
import 'package:car_wash/Utils/UI.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final String sessionId;
  final String selectedId;
  String date;
  String time;
  double lat;
  double lng;
  String carDetails;
  String paymentType;

  // const CheckoutPage(String sessionId, {Key key, this.sessionId}) : super(key: key);
  CheckoutPage(this.sessionId, this.selectedId, this.date, this.time, this.lat,
      this.lng, this.carDetails, this.paymentType);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Menifo menifo = Menifo();
  String url;
  String userId;
  int _paymentStatus;
  WebViewController _controller;

  Future<void> getUserId() async {
    DatabaseHelper db = DatabaseHelper.instance;
    List user = await db.getUser();
    userId = user[0]['user_id'];
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> _order() async {
    url = menifo.getBaseUrl() +
        "OrderCreate?customer_id=$userId&appointment_date=${widget.date}&appointment_time=${widget.time}&package_id=${widget.selectedId}&payment_status=$_paymentStatus&customer_lat=${widget.lat}&customer_long=${widget.lng}&customer_car=${widget.carDetails}&payment_type=${widget.paymentType}";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': "application/json"});
    print(response.body.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) => _controller = controller,
          onPageFinished: (String url) {
            if (url == initialUrl) {
              _redirectToStripe();
            }
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://success.com')) {
              setState(() {
                _paymentStatus = 1;
              });
              _order();
              // final transactionId = TransactionID().getTransactionId();
              // print("Transaction Id:" + transactionId);
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
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => AllBookings()));
                        })
                  ],
                  closeFunction: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => AllBookings()));
                  }).show();
              // Navigator.of(context).pop('success');
            } else if (request.url.startsWith('https://cancel.com')) {
              // Navigator.of(context).pop('cancel');
              setState(() {
                _paymentStatus = 0;
              });
              Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Payment not Completed",
                  // content: InkWell(child: Text("OK"), onTap: (){Navigator.pop(context);},),
                  style: AlertStyle(
                    isOverlayTapDismiss: false,
                  ),
                  buttons: [
                    DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => AllBookings()));
                        })
                  ],
                  closeFunction: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => AllBookings()));
                  }).show();
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  void _redirectToStripe() {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '${widget.sessionId}'
}).then(function (result) {
  result.error.message = 'Error'
});
''';
    print(_controller.evaluateJavascript(redirectToCheckoutJs));
    _controller.evaluateJavascript(redirectToCheckoutJs);
  }

  String get initialUrl =>
      'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';
}

const kStripeHtmlPage = '''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<style>
  h4 {
	text-align:center;
	display:block;
	margin-top:50vh;
     }
</style>
<body>
<h4>Redirecting to Payment Gateway.....</h4>
</body>
</html>
''';
