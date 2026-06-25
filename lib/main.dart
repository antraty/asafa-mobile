// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

// import 'package:asafa/master_detail_container.dart';
// import 'package:asafa/res/values/app_colors.dart';
import 'package:asafa/screens/about_screen.dart';
import 'package:asafa/screens/song_listing.dart';
import 'package:asafa/screens/song_detail.dart';
import 'package:flutter/material.dart';

// import 'master_detail_container.dart.bkp';
import 'res/values/app_colors.dart';
import 'screens/splash_screen.dart';
import 'package:asafa/screens/solfa_listing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Asafa',
        theme: _lightTheme(),
        color: AppColors.PRIMARY,
        initialRoute: '/list-songs',
        routes: {
          // '/': (BuildContext context) => SplashScreen(),
          '/about': (BuildContext context) => AboutScreen(),
          '/list-songs': (BuildContext context) => MainScreen(),
          // '/list-songs': (BuildContext context) => MasterDetailContainer(),
        });
  }

// Light theme of the app
  ThemeData _lightTheme() {
    return ThemeData(
        // This is the theme of your application.
        brightness: Brightness.light,
        // primaryColor: Colors.white,
        primaryColor: AppColors.PRIMARY,
        scaffoldBackgroundColor: AppColors.WHITE,
        useMaterial3: true,

        // textButton theme
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.DARK)),
        appBarTheme: AppBarTheme(
          foregroundColor: AppColors.PRIMARY,
        ),

        // Defining global appBar Theme
        /*  appBarTheme: AppBarTheme(
            // color: Colors.white,
            // backgroundColor: Colors.white,
            backgroundColor: AppColors.PRIMARY,
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.WHITE),
            toolbarTextStyle: const TextTheme(
              headline6: TextStyle(color: AppColors.WHITE, fontSize: 20),
            ).bodyText2,
            titleTextStyle: const TextTheme(
              headline6: TextStyle(
                  color: AppColors.WHITE,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ).headline6), */
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: AppColors.SECONDARY));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _onSongSelected(BuildContext context, dynamic song) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SongDetails(
            isInTabletLayout: false,
            song: song,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SongListing(
      songSelectedCallback: (song) => _onSongSelected(context, song),
    );
  }
}
