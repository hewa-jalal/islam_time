import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/models/bang.dart';

class BangApiClient {
  final _baseUrl =
      'http://api.aladhan.com/v1/calendarByCity?city=Baghdad&country=Iraq&method=3&month=06&year=2020#';
  final http.Client httpClient;

  BangApiClient({@required this.httpClient});

  Future<Bang> fetchBang() async {
    //  final url, separate parts for parameters
    final response = await this.httpClient.get(_baseUrl);
    if (response.statusCode != 200) {
      throw Exception('error getting bangs');
    }

    final json = jsonDecode(response.body);
    return Bang.fromJson(json, DateTime.now().day);
  }
}
