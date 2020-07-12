import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/models/method_number.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  MethodNumber selectedNumber = MethodNumber(3);
  List<int> methodNumbersList = [0, 0, 0, 0, 0, 0];
  final List<DropdownMenuItem> items = [];

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
              backgroundColor: Colors.grey[900],
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.blueGrey[700],
                          child: SearchableDropdown.single(
                            menuBackgroundColor: Colors.blueGrey[700],
                            items: MethodNumber.list.map(
                              (exNum) {
                                return DropdownMenuItem(
                                  child: Text(
                                    exNum.numberString,
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 20,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Tune Prayer times',
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        _buildMehtodNumberTiles(state.bang),
                        Spacer(),
                        buildButtonsRow(bloc),
                      ],
                    ),
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

  Row buildButtonsRow(BangBloc bloc) {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Get a new location',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[300],
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Ok',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[300],
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
}
