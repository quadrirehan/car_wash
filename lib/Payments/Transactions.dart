import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'constants.dart';

/// Only for demo purposes!
/// Don't you dare do it in real apps!
class TransactionID {
  Future<String> getTransactionId() async {

    final _secretKey = base64Encode(utf8.encode('$secretKey:'));
    final auth = 'Basic ' + _secretKey;
    // print("Auth: " + _secretKey);
    final body = {
      'limits': 5,
    };

    try {
      final result = await Dio().get(
        "https://api.stripe.com/v1/issuing/transactions",queryParameters: {'limit': 1},
        // data: body,
        // options: Options(
        //   headers: {HttpHeaders.authorizationHeader: auth},
        //   contentType: "application/x-www-form-urlencoded",
        // ),
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        )
      );
      print("Transaction Id From Transaction Class:" + result.data['data'][0]['id']);
      return result.data['data'][0]['id'];
    } on DioError catch (e, s) {
      print(e.response);
      throw e;
    }
  }
}
