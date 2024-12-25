import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maths_quiz_app/widgets/score_indicator.dart';

class ScoreIndicators extends StatelessWidget {
  final int score;
  final int highScore;


  ScoreIndicators({super.key,required this.score, required this.highScore});
  @override
  Widget build(BuildContext context) {
    print('Displaying HighScore: $highScore, Current Score: $score');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ScoreIndicator(label: 'HIGHSCORE',score: '$highScore',),
        SizedBox(width: 40.w,),
        ScoreIndicator(label: 'SCORE',score: '$score',),

      ],
    );

  }
}
