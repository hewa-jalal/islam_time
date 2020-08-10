import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  List<String> _cities = [];
  Future _citiesFiles;
  final _controller = TextEditingController();
  String _filter;
  String _userCity;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _citiesFiles = _getFiles();
    _controller.addListener(() => setState(() => _filter = _controller.text));
  }

  Future<List<String>> _getFiles() async => await _initFiles(context);

  Future<List<String>> _initFiles(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final filePaths =
        manifestMap.keys.where((String key) => key.contains('.txt')).toList();
    return filePaths;
  }

  void _saveLocationPrefs(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', 'Iraq, $cityName');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: _isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _controller,
                decoration: InputDecoration.collapsed(
                  fillColor: Colors.white,
                  hintText: 'Enter a city name for Iraq',
                ),
              ),
            ),
            body: BlocListener<BangBloc, BangState>(
              listener: (context, state) {
                if (state is BangLoaded) {
                  Get.off(
                    HomePage(
                      userLocation: 'Iraq, $_userCity',
                      showDialog: true,
                    ),
                  );
                }
              },
              child: FutureBuilder(
                future: _citiesFiles,
                builder: (context, snapshot) {
                  final bangBloc = BlocProvider.of<BangBloc>(context);
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final item = snapshot.data[index];
                              final regex = RegExp(r'\w+(?=\.)');
                              final iter = regex.allMatches(item);
                              for (var element in iter) {
                                _cities.add(
                                  item.substring(element.start, element.end),
                                );
                              }
                              if (_filter == null || _filter == '') {
                                return InkWell(
                                  onTap: () {
                                    _userCity = _cities[index];
                                    _saveLocationPrefs(_userCity);
                                    setState(() => _isLoading = true);
                                    bangBloc.add(
                                      GetBang(
                                        cityName: _cities[index],
                                        countryName: 'Iraq',
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(_cities[index],
                                        style: customRobotoStyle(
                                          5.0,
                                          Colors.black,
                                          FontWeight.normal,
                                        )),
                                  ),
                                );
                              } else {
                                return _cities[index]
                                        .toLowerCase()
                                        .contains(_filter.toLowerCase())
                                    ? InkWell(
                                        onTap: () {
                                          _userCity = _cities[index];
                                          _saveLocationPrefs(_userCity);
                                          setState(() => _isLoading = true);
                                          bangBloc.add(
                                            GetBang(
                                              cityName: _cities[index],
                                              countryName: 'Iraq',
                                            ),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(
                                            _cities[index],
                                            style: customRobotoStyle(
                                              5.0,
                                              Colors.black,
                                              FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
        _isLoading
            ? Center(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
      ],
    );
  }
}
