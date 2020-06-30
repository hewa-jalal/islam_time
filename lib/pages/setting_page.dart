import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/home_page_widgets.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool asTabs = false;
  MethodNumber selectedNumber;
  final List<DropdownMenuItem> items = [];

  static const String appTitle = "Search Choices demo";
  final String loremIpsum = "Lorem ipsum dolor sit amet,";

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get appBarActions {
    return ([
      Center(child: Text("Tabs:")),
      Switch(
        activeColor: Colors.white,
        value: asTabs,
        onChanged: (value) {
          setState(() {
            asTabs = value;
          });
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BangBloc>(context);
    return BlocBuilder<BangBloc, BangState>(
      builder: (context, state) {
        if (state is BangLoaded) {
          return WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              Get.to(HomePage(
                showDialog: false,
                bang: state.bang,
                userLocation: 'from setting',
              ));
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey,
                body: Column(
                  children: <Widget>[
                    Material(
                      child: SearchableDropdown.single(
                        items: MethodNumber.list.map((exNum) {
                          return DropdownMenuItem(
                            child: Text(exNum.numberString),
                            value: exNum,
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedNumber = value;
                          // bloc.add(FetchBangWithSettings(
                          //     methodNumber: selectedNumber.number));
                          print('SelectedNumber ${selectedNumber.number}');
                        },
                        value: selectedNumber,
                        hint: 'select one number',
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text('speda', style: customTextStyle())),
                        Flexible(
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                            )),
                            child: TextField(
                              style: customTextStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.yellow,
                      child: FlatButton(
                        child: Text('5', style: customTextStyle()),
                        onPressed: () {
                          bloc.add(FetchBangWithSettings(
                              methodNumber: selectedNumber.number));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class MethodNumber {
  int number;

  static final Map<int, String> map = {
    0: "Shia Ithna-Ansari",
    1: "University of Islamic Sciences, Karachi",
    2: "Islamic Society of North America",
    3: "Muslim World League",
    4: "Umm Al-Qura University, Makkah",
    5: "Egyptian General Authority of Survey",
    6: "Institute of Geophysics, University of Tehran",
    7: "Gulf Region",
    8: "Kuwait",
    9: "Qatar",
    10: "Majlis Ugama Islam Singapura, Singapore",
    11: "Union Organization islamic de France",
    12: "Diyanet İşleri Başkanlığı, Turkey",
    13: "Spiritual Administration of Muslims of Russia",
  };

  String get numberString {
    return (map.containsKey(number) ? map[number] : "unknown");
  }

  MethodNumber(this.number);

  String toString() {
    return ("${map[number]}");
  }

  static List<MethodNumber> get list {
    return (map.keys.map((num) {
      return (MethodNumber(num));
    })).toList();
  }
}
