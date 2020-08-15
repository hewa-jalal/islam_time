import 'package:flutter/material.dart';

class FetchSetting {
  final int methodNumber;
  final List<String> tuning;
  const FetchSetting({
    @required this.methodNumber,
    @required this.tuning,
  });

  List<int> get tuningInt => tuning.map((e) => int.parse(e)).toList();
}
