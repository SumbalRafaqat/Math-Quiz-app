import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maths_quiz_app/sceens/1st_screen.dart';
import 'dart:async';
import '../utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GetStarted()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80.h,
                width: 80.w,
                decoration: BoxDecoration(
                    image: DecorationImage(image: Images.splashScreen)),
              ),
              Container(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('EXPERT MATH \n       TUTOR',
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
