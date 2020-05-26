import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:islamtime/read_file.dart';

var read = ReadFile();

void main() {
  runApp(MyApp());
}







class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: FlatButton(
              onPressed: read.loadAsset,
              child: Icon(
                Icons.add_circle,
                color: Colors.yellow,
                size: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
