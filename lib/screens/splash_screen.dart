import 'package:asafa/res/values/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Choose screen'),
      // ),
      body: Container(
        color: AppColors.WHITE,
        child: _splashScreenContent(context),
      ),
    );
  }
}

Widget _splashScreenContent(context) {
  return SafeArea(
    child: Stack(children: [
      Container(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Asafa',
              style: TextStyle(
                  color: AppColors.PRIMARY,
                  fontSize: 48,
                  fontWeight: FontWeight.w500),
            ),
            Container(
              child: Text(
                'Fihirana FFBBM',
                style: TextStyle(color: AppColors.PRIMARY, fontSize: 18),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  child: Text('test : Go to song list'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/list-songs');
                  },
                ))
          ],
        )),
      ),
    ]),
  );
}
