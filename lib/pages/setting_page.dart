import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/method_number.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:islamtime/size_config.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'athkar_page.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List<DropdownMenuItem> items = [];
  List<int> methodNumbersList = [0, 0, 0, 0, 0, 0];
  MethodNumber selectedNumber = MethodNumber(3);

  @override
  void initState() {
    _getPrefs();
    super.initState();
  }

  Container _buildSearchableDropdown() {
    return Container(
      color: Colors.blueGrey[700],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          menuBackgroundColor: Colors.blueGrey[700],
          style: GoogleFonts.farro(
            fontSize: SizeConfig.safeBlockHorizontal * 5.4,
            color: Colors.white,
          ),
          items: MethodNumber.list.map(
            (exNum) {
              return DropdownMenuItem(
                child: Text(
                  exNum.numberString,
                  style: GoogleFonts.robotoCondensed(
                    fontSize: SizeConfig.safeBlockHorizontal * 5.4,
                    color: Colors.white,
                  ),
                ),
                value: exNum,
              );
            },
          ).toList(),
          onChanged: (value) => selectedNumber = value,
          value: selectedNumber,
          hint: 'Select a method',
          isExpanded: true,
        ),
      ),
    );
  }

  Row _buildButtonsRow(BangBloc bloc) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Get a new location',
                  style: customRobotoStyle(
                    4.4,
                    Colors.amber[300],
                  ),
                ),
              ),
              color: Colors.blueGrey[700],
              onPressed: () => bloc.add(FetchBang()),
            ),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Ok',
                  style: customRobotoStyle(
                    4.4,
                    Colors.amber[300],
                  ),
                ),
              ),
              color: Colors.blueGrey[700],
              onPressed: () => bloc.add(
                FetchBangWithSettings(
                  methodNumber: selectedNumber.number,
                  tuning: methodNumbersList,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildMehtodNumberTiles(Bang bang) {
    return Column(
      children: <Widget>[
        MethodNumberTile(
          prayerName: 'Fajr',
          prayerTime: bang.speda,
          onChange: (val) => methodNumbersList[0] = int.parse(val),
        ),
        MethodNumberTile(
          prayerTime: bang.rojHalat,
          prayerName: 'Sunrise',
          onChange: (val) => methodNumbersList[1] = int.parse(val),
        ),
        MethodNumberTile(
          prayerTime: bang.nevro,
          prayerName: 'Zuhr',
          onChange: (val) => methodNumbersList[2] = int.parse(val),
        ),
        MethodNumberTile(
          prayerTime: bang.evar,
          prayerName: 'Asr',
          onChange: (val) => methodNumbersList[3] = int.parse(val),
        ),
        MethodNumberTile(
          prayerTime: bang.maghrab,
          prayerName: 'Maghrib',
          onChange: (val) => methodNumbersList[4] = int.parse(val),
        ),
        MethodNumberTile(
          prayerTime: bang.aesha,
          prayerName: 'Isha',
          isEnd: true,
          onChange: (val) => methodNumbersList[5] = int.parse(val),
        ),
      ],
    );
  }

  void _getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    int p = prefs.getInt('methodNumber');
    print('p inside settingpage => $p');
    selectedNumber = MethodNumber(prefs.getInt('methodNumber')) ?? 3;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BangBloc>(context);
    return BlocConsumer<BangBloc, BangState>(
      listener: (context, state) {
        if (state is BangLoaded) {
          Get.to(
            HomePage(
              showDialog: false,
              userLocation: 'from setting',
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is BangLoaded) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Settings',
                  style: customRobotoStyle(
                    5.4,
                    Colors.white,
                  ),
                ),
                backgroundColor: Colors.blueGrey[700],
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.blockSizeVertical * 1.0),
                    child: FlatButton(
                      child: Text(
                        'Last Third Athkar',
                        style: customRobotoStyle(
                          3.0,
                          Colors.white,
                        ),
                      ),
                      onPressed: () => Get.to(AthkarPage()),
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
              body: Container(
                color: Colors.blueGrey[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            _buildSearchableDropdown(),
                            Padding(
                              padding: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical * 2.2,
                                left: SizeConfig.safeBlockVertical * 0.2,
                              ),
                              child: Text(
                                'Tune prayer times (in minutes)',
                                style: customRobotoStyle(6.0, Colors.white),
                              ),
                            ),
                            SizedBox(height: SizeConfig.safeBlockVertical * 2),
                            _buildMehtodNumberTiles(state.bang),
                          ],
                        ),
                      ),
                      _buildButtonsRow(bloc),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container(
          color: Colors.blueGrey[700],
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
