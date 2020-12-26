import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:mootclub_app/AppBarWidget.dart';
import 'package:mootclub_app/Carousel.dart';


class LandingPage extends StatefulWidget{
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SizedBox(height: size.height/30),
            Text('Live',style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: size.width/10,
            ),
            ),
            SizedBox(height: size.height/50),
            Carousel(),
          ],
        ),
      ),


    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
