import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 250.0,
          height: 80,
          child: TypewriterAnimatedTextKit(
            isRepeatingAnimation: false,
            speed: const Duration(milliseconds: 125),
            text: [
              'Join your \nfavourite clubs.',
            ],
            textStyle: TextStyle(
              fontSize: 30.0,
              fontFamily: "Lato",
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent, width: 10)),
          child:
              Image.asset("assets/gifs/LandingPage.gif", width: 80, height: 80),
        )
      ],
    );
  }
}
