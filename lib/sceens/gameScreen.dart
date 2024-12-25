import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../widgets/score_indicators.dart';
import '1st_screen.dart';

class MathQuizGame extends StatefulWidget {
  @override
  _MathQuizGameState createState() => _MathQuizGameState();
}

class _MathQuizGameState extends State<MathQuizGame> {
  int maxTime = 60;
  double timeLeft = 1.0; // Represents percentage (from 1.0 to 0.0)
  int currentSeconds = 60; // Total time in seconds
  Timer? timer;
  String question = '';
  bool correctAnswer = false;
  int score = 0;
  int highScore = 0;
  int totalQuizes= 1;
  String answerFeedback = '';

  @override
  void initState() {
    super.initState();
    loadHighScore();
    generateQuestion();
    startTimer();
    score=0;
    totalQuizes= 1;
  }
  Future<void> loadHighScore() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      highScore = preferences.getInt('highScore') ?? 0;
    });
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (Timer timer) {
      setState(() {
        if (currentSeconds > 0) {
          currentSeconds--;
          timeLeft = currentSeconds / maxTime; // Update the percent value
        } else {
          myDialog();
          timer.cancel(); // Time is up
        }
      });
    });
  }

  // Function to generate a random math question
  void generateQuestion() {
    Random random = Random();

    // Randomly choose between a simple operation (Add/Subtract/Multiply/Divide) or a DMAS expression
    bool isComplexExpression = random.nextBool(); // 50% chance of a DMAS rule question

    if (isComplexExpression) {
      // Complex DMAS-based question

      // Generate 4 random numbers
      int num1 = random.nextInt(10) + 1;
      int num2 = random.nextInt(10) + 1;
      int num3 = random.nextInt(10) + 1;
      int num4 = random.nextInt(10) + 1;

      // Generate a DMAS expression: Multiplication and Division first, then Addition/Subtraction
      int divisionResult = num1 * num2; // Ensuring division produces a whole number
      int divisionPart = divisionResult ~/ num1; // (num1 * num2) ÷ num1 = num2
      int multiplicationPart = num3 * num4;

      // Randomly choose an operation for the final combination
      if (random.nextBool()) {
        question = '($divisionResult ÷ $num1) + ($num3 × $num4) = ${divisionPart + multiplicationPart}';
        correctAnswer = true;
      } else {
        // Introduce a random error to make the answer incorrect
        int incorrectAnswer = (divisionPart + multiplicationPart) + random.nextInt(3) - 1;
        question = '($divisionResult ÷ $num1) + ($num3 × $num4) = $incorrectAnswer';
        correctAnswer = false;
      }

    } else {
      // Simple operation: addition, subtraction, multiplication, or division

      int num1 = random.nextInt(20) + 1;
      int num2 = random.nextInt(20) + 1;
      int operation = random.nextInt(4); // Randomly pick an operation

      switch (operation) {
        case 0: // Addition
          if (random.nextBool()) {
            question = '$num1 + $num2 = ${num1 + num2}';
            correctAnswer = true;
          } else {
            question = '$num1 + $num2 = ${num1 + num2 + random.nextInt(3) - 1}';
            correctAnswer = false;
          }
          break;
        case 1: // Subtraction
          if (random.nextBool()) {
            question = '$num1 - $num2 = ${num1 - num2}';
            correctAnswer = true;
          } else {
            question = '$num1 - $num2 = ${num1 - num2 + random.nextInt(3) - 1}';
            correctAnswer = false;
          }
          break;
        case 2: // Multiplication
          if (random.nextBool()) {
            question = '$num1 × $num2 = ${num1 * num2}';
            correctAnswer = true;
          } else {
            question = '$num1 × $num2 = ${num1 * num2 + random.nextInt(3) - 1}';
            correctAnswer = false;
          }
          break;
        case 3: // Division (Ensuring integer division)
          int result = num1 * num2; // Make sure division results in an integer
          if (random.nextBool()) {
            question = '$result ÷ $num1 = $num2';
            correctAnswer = true;
          } else {
            question = '$result ÷ $num1 = ${num2 + random.nextInt(3) - 1}';
            correctAnswer = false;
          }
          break;
      }
    }
  }

  void checkAnswer(bool userAnswer) async {
    if (userAnswer == correctAnswer) {
      score++;
      currentSeconds = (currentSeconds + 2).clamp(0, maxTime);
       answerFeedback = 'CORRECT';

      if (highScore < score) {
        highScore = score;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('highScore', highScore);
      }
    } else {
      currentSeconds = (currentSeconds - 2).clamp(0, maxTime);
       answerFeedback = 'INCORRECT';

    }

    setState(() {
      timeLeft = currentSeconds / maxTime; // Update the circular percent
      generateQuestion();
    });
  }
  Future<void> myDialog(){
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'GAME OVER',
              style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold
              ),
            ),
            content: Text(
              'Score: $score | $totalQuizes',style: TextStyle(
                fontSize: 22.sp,
                fontWeight:FontWeight.bold
            ),
            ),
            actions: [
              TextButton(onPressed: (){
                SystemNavigator.pop();
              }, child: Text(
                  'EXIT'
              )),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStarted()));
              }, child: Text(
                  'PLAY AGAIN'
              ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey,Colors.yellowAccent,Colors.grey]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreIndicators(score: score, highScore: highScore,),
            SizedBox(height: 20.h),

            Container(
              height: 70.h,
              width: 350.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30).r,
                  border: Border.all(
                      color: Colors.black
                  )
              ),

              child: Center(
                child: Text(
                  question,
                  style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              answerFeedback,
              style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: answerFeedback == 'CORRECT' ? Colors.green : Colors.red),
            ),
            SizedBox(height: 40.h),
            CircularPercentIndicator(
              radius: 100.r,
              lineWidth: 13.0,
              percent: timeLeft,
              center: Text(
                '$currentSeconds sec',
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
              progressColor: timeLeft > 0.5 ? Colors.green : timeLeft > 0.25 ? Colors.orange : Colors.red,
            ),
            SizedBox(height: 40.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    totalQuizes++;
                    checkAnswer(true);
                  },
                  child: Text(
                    'TRUE',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Splash color when pressed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                      side: BorderSide(
                        color: Colors.black26, // Border color
                        width: 3.0, // Border width
                      ),
                    ),
                    shadowColor: Colors.black, // Shadow color
                    elevation: 8.0, // Elevation to give a 3D effect
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    totalQuizes++;
                    checkAnswer(false);
                  },
                  child: Text(
                    'FALSE',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Colors.black26,
                        width: 3.0,
                      ),
                    ),
                    shadowColor: Colors.black,
                    elevation: 8.0,
                  ),
                ),

              ],
            ),


          ],
        ),
      ),
    );
  }
}
