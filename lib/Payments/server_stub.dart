import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'constants.dart';

/// Only for demo purposes!
/// Don't you dare do it in real apps!
class Server {
  Future<String> createCheckout(String id) async {
    String _price;

    switch (id) {
      case "1":
        _price = premium_car_wash;
        break;
        case "2":
        _price = standard_car_wash;
        break;
      case "3":
        _price = regular_car_wash;
        break;
    }

    final auth = 'Basic ' + base64Encode(utf8.encode('$secretKey:'));
    final body = {
      'payment_method_types': ['card'],
      'line_items': [
        {
          'price': _price,
          'quantity': 1,
        },
      ],
      'mode': 'payment',
      'success_url': 'https://success.com/{CHECKOUT_SESSION_ID}',
      'cancel_url': 'https://cancel.com/',
    };

    try {
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",

        ),
      );
      return result.data['id'];
    } on DioError catch (e, s) {
      print(e.response);
      throw e;
    }
  }
}
