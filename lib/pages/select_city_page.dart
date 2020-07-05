import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  Future citiesFiles;
  List<String> cities = [];
  TextEditingController controller = TextEditingController();
  String filter;
  String userCity;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    citiesFiles = getFiles();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  Future<List<String>> getFiles() async {
    return await _initFiles(context);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AbsorbPointer(
          absorbing: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: controller,
                decoration: InputDecoration.collapsed(
                    fillColor: Colors.white, hintText: 'Enter a city name'),
              ),
            ),
            body: BlocListener<BangBloc, BangState>(
              listener: (context, state) {
                if (state is BangLoaded) {
                  Get.off(
                    HomePage(
                      userLocation: 'Iraq, $userCity',
                      showDialog: true,
                    ),
                  );
                }
              },
              child: FutureBuilder(
                future: citiesFiles,
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
                              final String item = snapshot.data[index];
                              final regex = RegExp(r'\w+(?=\.)');
                              Iterable iter = regex.allMatches(item);
                              for (var element in iter) {
                                cities.add(
                                    item.substring(element.start, element.end));
                              }
                              if (filter == null || filter == '') {
                                return InkWell(
                                  onTap: () {
                                    userCity = cities[index];
                                    saveLocationPrefs(userCity);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    bangBloc.add(
                                      GetBang(
                                          cityName: cities[index],
                                          countryName: 'Iraq'),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(cities[index]),
                                  ),
                                );
                              } else {
                                return cities[index]
                                        .toLowerCase()
                                        .contains(filter.toLowerCase())
                                    ? InkWell(
                                        onTap: () {
                                          userCity = cities[index];
                                          saveLocationPrefs(userCity);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          bangBloc.add(
                                            GetBang(
                                                cityName: cities[index],
                                                countryName: 'Iraq'),
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(cities[index]),
                                        ),
                                      )
                                    : Container();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ),
        isLoading
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

  Future<List<String>> _initFiles(BuildContext context) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final filePaths = manifestMap.keys
        .where((String key) => key.contains('fixed_prayer_time/Iraq/'))
        .where((String key) => key.contains('.txt'))
        .toList();
    return filePaths;
  }

  void saveLocationPrefs(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', 'Iraq, $cityName');
  }
}
