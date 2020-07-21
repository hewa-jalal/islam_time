import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:islamtime/custom_widgets_and_styles/custom_styles_formats.dart';

class AthkarPage extends StatelessWidget {
  FlatButton _buildDoneButton() {
    return FlatButton(
      child: Icon(
        Icons.done,
        color: Colors.white,
      ),
      color: Colors.green,
      onPressed: () => Get.back(),
    );
  }

  Expanded _buildMarkdown(AsyncSnapshot<String> snapshot) {
    return Expanded(
      child: Markdown(
        data: snapshot.data,
        styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
        styleSheet: MarkdownStyleSheet(
          p: customRobotoStyle(
            4.4,
            Colors.white,
            FontWeight.normal,
          ),
          h1: customRobotoStyle(6.5, Colors.white),
          h2: customRobotoStyle(5.5, Colors.white),
          h3: customRobotoStyle(5.5, Colors.white),
          blockquote: customRobotoStyle(5.0, Colors.black),
          blockquoteAlign: WrapAlignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: FutureBuilder<String>(
          future: rootBundle.loadString('assets/athkar/athkar.md'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildMarkdown(snapshot),
                  _buildDoneButton(),
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
