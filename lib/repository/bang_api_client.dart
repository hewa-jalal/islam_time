import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/models/bang.dart';

class BangApiClient {
  final _baseUrl = 'http://api.aladhan.com/v1/calendar?';
  final http.Client httpClient;

  BangApiClient({@required this.httpClient});

  Future<Bang> fetchBang({
    @required double lat,
    @required double lng,
    @required int month,
    @required int year,
    int method,
    List<int> tuning,
  }) async {
    final url = _baseUrl +
        'latitude=$lat&longitude=$lng&method=$method&month=$month&year=$year&tune=0,${tuning[0]},${tuning[1]},${tuning[2]},${tuning[3]},${tuning[4]},0,${tuning[5]}';
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }
    final json = jsonDecode(response.body);
    return Bang.fromJsonRequest(json, DateTime.now().day - 1);
  }
}
