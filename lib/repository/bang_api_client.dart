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
  }) async {
    final url = _baseUrl +
        'latitude=$lat&longitude=$lng&method=$method&month=$month&year=$year';
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }
    final json = jsonDecode(response.body);
    return Bang.fromJson(json, DateTime.now().day - 1);
  }
}
