import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/models/bang.dart';

class BangApiClient {
  final _baseUrl = 'http://api.aladhan.com/v1/calendar?';
  final http.Client httpClient;

  BangApiClient({@required this.httpClient});

  Future<Bang> fetchBang(
      double latitude, double longtitude, int month, int year) async {
    final url = _baseUrl +
        'latitude=$latitude&longitude=$longtitude&method=2&month=$month&year=$year';
    //  final url, separate parts for parameters
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }

    final json = jsonDecode(response.body);
    return Bang.fromJson(json, DateTime.now().day);
  }
}
