import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/models/bang.dart';
import 'package:islamtime/pages/home_page.dart';

class SelectCityPage extends StatefulWidget {
  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  List<String> cities = [];
  TextEditingController controller = TextEditingController();
  String filter;
  String userCity;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => HomePage(
                      bang: state.bang, userLocation: 'Iraq, $userCity')),
            );
          }
        },
        child: FutureBuilder(
          future: _initFiles(context),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
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
                          cities
                              .add(item.substring(element.start, element.end));
                        }
                        if (filter == null || filter == '') {
                          return InkWell(
                            onTap: () {
                              userCity = cities[index];
                              final bangBloc =
                                  BlocProvider.of<BangBloc>(context);
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
                                    final bangBloc =
                                        BlocProvider.of<BangBloc>(context);
                                    bangBloc.add(GetBang(
                                        cityName: cities[index],
                                        countryName: 'Iraq'));
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
}
