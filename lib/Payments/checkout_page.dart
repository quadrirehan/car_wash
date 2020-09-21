import 'dart:convert';
import 'package:car_wash/AllBookings.dart';
import 'package:car_wash/Utils/DatabaseHelper.dart';
import 'package:car_wash/Utils/UI.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Transactions.dart';
import 'constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final String sessionId;
  final String selectedId;
  String date;

  // const CheckoutPage(String sessionId, {Key key, this.sessionId}) : super(key: key);
  CheckoutPage(this.sessionId, this.selectedId, this.date);

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
        "Order?customer_id=$userId&appointment_date=${widget.date}&package_id=${widget.selectedId}&payment_status=$_paymentStatus";
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
                  buttons: [],
                  closeFunction: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AllBookings()));
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                  }).show();
              // Navigator.of(context).pop('success');
            } else if (request.url.startsWith('https://cancel.com')) {
              // Navigator.of(context).pop('cancel');
              setState(() {
                _paymentStatus = 0;
              });
              _order();
              Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Payment not Completed",
                  // content: InkWell(child: Text("OK"), onTap: (){Navigator.pop(context);},),
                  style: AlertStyle(
                    isOverlayTapDismiss: false,
                  ),
                  buttons: [],
                  closeFunction: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => AllBookings()));
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    // Navigator.pop(context);
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
  h3 {
	text-align:center;
	display:block;
	margin-top:45vh;
     }
</style>
<body>
<h1>Redirecting to Payment Gateway.....</h1>
</body>
</html>
''';
