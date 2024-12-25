import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreIndicator extends StatelessWidget {
  final label;
  final score;
   ScoreIndicator({this.label,this.score});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0).r,
      child: Column(
        children: [
          Text(label,style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 30.sp
          ),),
          SizedBox(
            height: 10.h,
          ),
          Text(score,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp
              )),

        ],
      ),
    );
  }
}
