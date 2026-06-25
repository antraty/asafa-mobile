import 'dart:convert';
import 'package:asafa/res/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fanazavana'),
      ),
      body: Container(
        color: AppColors.WHITE,
        child: _aboutScreenContent(context),
      ),
    );
  }
}

Future<String> getAboutTextContent() async {
  return await rootBundle.loadString('assets/songs/about.xml');
}

Widget _aboutScreenContent(context) {
  return SafeArea(
    child: ListView(shrinkWrap: true, children: [
      FutureBuilder(
          future: getAboutTextContent(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              // return Text('Loading...');
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // String contentBase64 =
            //     base64Encode(const Utf8Encoder().convert(snapshot.data));
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                margin: EdgeInsets.only(top: 8.0, bottom: 8),
                child: _buildTextContent(snapshot.data));
          }),
    ]),
  );
}

Widget _buildTextContent(htmlText) {
  // build lyric content
  return HtmlWidget(
    htmlText,
    onTapUrl: (url) async {
      if (!await launchUrlString(url)) {
        print("can not launch $url");
        return false;
      }
      return true;
    },
    /* onTapUrl: (url) async {
      if (!await launch(url)) {
        print("can not launch $url");
      }
    }, */
    customWidgetBuilder: (element) {
      if (element.localName == 'properties') {
        // hide properties tag
        return SizedBox(width: 0, height: 0);
      }
      return null;
    },
    customStylesBuilder: (element) {
      // CSS Styles of an element
      Map<String, String> style = {};

      if (element.localName == 'properties') {
        // hide properties tag
        style['display'] = 'none';
        style['margin'] = '0px';
        style['padding'] = '0px';
        return style;
      }

      if (element.localName == 'verse' || element.classes.contains('verse')) {
        style['display'] = 'block';
        style['margin-bottom'] = '32px';
        style['color'] = AppColors.TEXT_BLACK_CSS;
      }
      if (element.localName == 'chorus' || element.classes.contains('chorus')) {
        style['font-style'] = 'normal';
        style['margin-left'] = '24px';
      }
      if (element.localName == 'line' ||
          element.localName == 'lines' ||
          element.localName == 'p') {
        style['font-family'] = 'Times New Roman';
        style['line-height'] = '1.8';
        style['display'] = 'block';
        style['color'] = AppColors.TEXT_BLACK_CSS;
        // text size
        style['font-size'] = AppSize.TEXT_SIZE_NORMAL.toString() + 'px';
      }

      if (element.localName == 'subtitle' ||
          element.classes.contains('subtitle')) {
        // hide properties tag
        style['color'] = AppColors.TEXT_BLACK_CSS;
        return style;
      }
      if (element.localName == 'separator' ||
          element.classes.contains('separator')) {
        // hide properties tag
        style['margin-top'] = '16px';
        style['margin-bottom'] = '16px';
        style['color'] = AppColors.TEXT_PRIMARY_CSS;
        return style;
      }
      if (element.classes.contains('batista-info')) {
        // hide properties tag
        style['border-top'] = '1px solid $AppColors.TEXT_PRIMARY_CSS';
        style['border-bottom'] = '1px solid $AppColors.TEXT_PRIMARY_CSS';
        style['margin-top'] = '18px';
        style['padding-top'] = '16px';
        style['margin-bottom'] = '12px';
        style['padding-bottom'] = '12px';
        style['color'] = AppColors.TEXT_PRIMARY_CSS;
        return style;
      }
      if (element.classes.contains('group-info')) {
        // hide properties tag
        style['border-top'] = '1px solid $AppColors.TEXT_PRIMARY_CSS';
        style['margin-top'] = '18px';
        style['padding-top'] = '16px';
        // style['margin-bottom'] = '12px';
        // style['padding-bottom'] = '12px';
        style['color'] = AppColors.TEXT_BLACK_CSS;
        return style;
      }
      if (element.classes.contains('asafa-info')) {
        // hide properties tag
        style['color'] = AppColors.TEXT_PRIMARY_CSS;
        return style;
      }
      return style;
    },
  );
}
