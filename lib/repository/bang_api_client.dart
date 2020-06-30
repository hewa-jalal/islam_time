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
    print('lat $latitude, lon $longtitude, month $month, year $year');
    final url = _baseUrl +
        'latitude=$latitude&longitude=$longtitude&method=3&month=$month&year=$year';
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }
    final json = jsonDecode(response.body);
    return Bang.fromJson(json, DateTime.now().day - 1);
  }

  Future<Bang> fetchBangWithSetting(double latitude, double longtitude,
      int month, int year, int method) async {
    final url = _baseUrl +
        'latitude=$latitude&longitude=$longtitude&method=$method&month=$month&year=$year';
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }
    final json = jsonDecode(response.body);
    return Bang.fromJson(json, DateTime.now().day - 1);
  }
}
