import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamtime/bloc/bang_bloc.dart';
import 'package:islamtime/custom_widgets_and_styles/home_page_widgets/home_page_widgets.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BangBloc>(context);
    return BlocBuilder<BangBloc, BangState>(
      builder: (context, state) {
        if (state is BangLoaded) {
          return Container(
            color: Colors.yellow,
            child: FlatButton(
              child: Text('5', style: customTextStyle()),
              onPressed: () {
                bloc.add(FetchBang());
              },
            ),
          );
        }
      },
    );
  }
}
