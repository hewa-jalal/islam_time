import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/home_page_widgets.dart';

class NetworkPage extends StatefulWidget {
  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BangBloc, BangState>(
      builder: (context, state) {
        if (state is BangInitial) {
          BlocProvider.of<BangBloc>(context).add(
              GetBang(countryName: 'dd', cityName: 'rr'));
        }
        if (state is BangError) {
          return Center(
            child: Text('Error State'),
          );
        }
        if (state is BangLoaded) {
          return Column(
            children: <Widget>[
              Text('${state.bang.speda}', style: customTextStyle()),
              Text('${state.bang.rojHalat}', style: customTextStyle()),
              Text('${state.bang.nevro}', style: customTextStyle()),
              Text('${state.bang.evar}', style: customTextStyle()),
              Text('${state.bang.maghrab}', style: customTextStyle()),
              Text('${state.bang.aesha}', style: customTextStyle()),
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
