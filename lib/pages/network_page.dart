import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkPage extends StatefulWidget {
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlatButton(
            child: Text('Network Request'),
            onPressed: () => fetchPrayer(),
          ),
        ),
      ),
    );
  }

  Future<void> fetchPrayer() async {
    print('inside fetchPrayer() method');
    final response = await http.get(
        'http://api.aladhan.com/v1/calendarByCity?city=Baghdad&country=Iraq&method=5&month=06&year=2020');
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get prayers');
    }
  }
}
