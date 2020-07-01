import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/home_page_widgets.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool asTabs = false;
  MethodNumber selectedNumber = MethodNumber(3);
  List<int> methodNumbersList = [0, 0, 0, 0, 0, 0];
  final List<DropdownMenuItem> items = [];

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
                body: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    child: Column(
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
                            hint: 'select a method',
                            isExpanded: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        MethodNumberTile(
                          prayerName: 'Fajr',
                          onChange: (val) =>
                              methodNumbersList[0] = int.parse(val),
                        ),
                        MethodNumberTile(
                          prayerName: 'Sunrise',
                          onChange: (val) =>
                              methodNumbersList[1] = int.parse(val),
                        ),
                        MethodNumberTile(
                          prayerName: 'Zuhr',
                          onChange: (val) =>
                              methodNumbersList[2] = int.parse(val),
                        ),
                        MethodNumberTile(
                          prayerName: 'Asr',
                          onChange: (val) =>
                              methodNumbersList[3] = int.parse(val),
                        ),
                        MethodNumberTile(
                          prayerName: 'Maghrib',
                          onChange: (val) =>
                              methodNumbersList[4] = int.parse(val),
                        ),
                        MethodNumberTile(
                          prayerName: 'Isha',
                          isEnd: true,
                          onChange: (val) =>
                              methodNumbersList[5] = int.parse(val),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            color: Colors.yellow,
                            child: FlatButton(
                              child: Text('ok', style: customTextStyle()),
                              onPressed: () {
                                bloc.add(
                                  FetchBangWithSettings(
                                    methodNumber: selectedNumber.number,
                                    tuning: methodNumbersList,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class MethodNumberTile extends StatelessWidget {
  final bool isEnd;
  final String prayerName;
  final Function onChange;
  const MethodNumberTile({
    Key key,
    this.isEnd = false,
    @required this.prayerName,
    @required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lime[900],
      child: ListTile(
        dense: true,
        title: Text(prayerName, style: customTextStyle()),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.amber[500],
              ),
            ),
            width: 80,
            child: TextField(
              maxLength: 2,
              maxLengthEnforced: true,
              keyboardType: TextInputType.number,
              textInputAction:
                  isEnd ? TextInputAction.done : TextInputAction.next,
              decoration:
                  InputDecoration(border: InputBorder.none, counterText: ''),
              onSubmitted: (_) {
                isEnd
                    ? FocusScope.of(context).unfocus()
                    : FocusScope.of(context).nextFocus();
              },
              style: GoogleFonts.roboto(
                fontSize: 30,
                color: Colors.white,
              ),
              onChanged: onChange,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
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
