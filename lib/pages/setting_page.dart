import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/appbar_setting_button.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_text.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/method_number_tile.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:islamtime/pages/language_selection_page.dart';
import 'package:islamtime/services/size_config.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamtime/i18n/prayer_and_time_names_i18n.dart';
import 'package:islamtime/i18n/setting_page_i18n.dart';
import 'athkar_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  void _getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedNumber = MethodNumber(prefs.getInt('methodNumber')) ?? 3;
  }

  Widget _buildSearchableDropdown() {
    return Container(
      color: Colors.blueGrey[700],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SearchableDropdown.single(
          closeButton: FlatButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close'.i18n2,
              style: customRobotoStyle(4.5, Colors.white),
            ),
          ),
          menuBackgroundColor: Colors.blueGrey[700],
          style: GoogleFonts.farro(
            fontSize: SizeConfig.safeBlockHorizontal * 5.0,
            color: Colors.white,
          ),
          items: MethodNumber.list.map(
            (exNum) {
              return DropdownMenuItem(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      exNum.numberString,
                      size: 5.4,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                value: exNum,
              );
            },
          ).toList(),
          onChanged: (value) => selectedNumber = value,
          value: selectedNumber,
          hint: 'Select a method'.i18n2,
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildButtonsRow(BangBloc bloc) {
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
                  'Get a new location'.i18n2,
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
                  'Ok'.i18n2,
                  style: customRobotoStyle(
                    4.4,
                    Colors.amber[300],
                  ),
                ),
              ),
              color: Colors.blueGrey[700],
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
    );
  }

  Widget _buildMehtodNumberTilesColumn(Bang bang) {
    return Column(
      children: <Widget>[
        MethodNumberTile(
          prayerName: 'Fajr'.i18n,
          prayerTime: bang.speda,
          onChange: (val) => methodNumbersList[0] = int.parse(val),
        ),
        MethodNumberTile(
          prayerName: 'Sunrise'.i18n,
          prayerTime: bang.rojHalat,
          onChange: (val) => methodNumbersList[1] = int.parse(val),
        ),
        MethodNumberTile(
          prayerName: 'Zuhr'.i18n,
          prayerTime: bang.nevro,
          onChange: (val) => methodNumbersList[2] = int.parse(val),
        ),
        MethodNumberTile(
          prayerName: 'Asr'.i18n,
          prayerTime: bang.evar,
          onChange: (val) => methodNumbersList[3] = int.parse(val),
        ),
        MethodNumberTile(
          prayerName: 'Maghrib'.i18n,
          prayerTime: bang.maghrab,
          onChange: (val) => methodNumbersList[4] = int.parse(val),
        ),
        MethodNumberTile(
          prayerName: 'Isha'.i18n,
          prayerTime: bang.aesha,
          isEnd: true,
          onChange: (val) => methodNumbersList[5] = int.parse(val),
        ),
      ],
    );
  }

  AppBar _buildSettingAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey[700],
      actions: <Widget>[
        AppBarSettingButton(
          text: 'Last third deeds',
          onPressed: () => Get.to(AthkarPage()),
        ),
        AppBarSettingButton(
          text: 'Change Langauge',
          onPressed: () => Get.to(LanguageSelectionPage(isFromSetting: true)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bangBloc = BlocProvider.of<BangBloc>(context);
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
              appBar: _buildSettingAppBar(),
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
                                top: SizeConfig.safeBlockVertical * 1.0,
                                left: SizeConfig.safeBlockVertical * 0.2,
                              ),
                              child: CustomText(
                                'Tune prayer times (in minutes)'.i18n2,
                                size: 5.6,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.safeBlockVertical * 2.0),
                            _buildMehtodNumberTilesColumn(state.bang),
                          ],
                        ),
                      ),
                      _buildButtonsRow(bangBloc),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container(
          color: Colors.blueGrey[700],
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
