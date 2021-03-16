import 'package:flutter/material.dart';

class ProfileTopBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          // 10% of the width, so there are ten blinds.
          end: Alignment(0.5, 0.0),
          colors: [
            const Color(0xfffa939e),
            const Color(0xffad1323)
            //  const Color(0xffd90000)
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
    );
  }
}
