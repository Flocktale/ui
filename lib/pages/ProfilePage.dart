import 'package:flutter/material.dart';

import '../AppBarWidget.dart';
import '../Carousel.dart';
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                color: Colors.amber,
              ),
              AppBarWidget(),//AppBar
              Positioned(
                top:((size.height/14)+(size.height/9)-(size.height/25)),
                height: size.height - ((size.height/14)+(size.height/9)-(size.height/25)),
                width: size.width,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0),topRight: Radius.circular(45.0)),

                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: size.height/20),
                        Text(
                          'Caroline Steele',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width/20,
                            color: Colors.red[300],
                          ),
                        ),
                        SizedBox(height: size.height/100,),
                        Text(
                          'Music Composer',
                          style: TextStyle(
                              fontSize: size.width/26,
                              color: Colors.grey[400]
                          ),
                        ),
                        SizedBox(height: size.height/50,),
                        Container(
                          margin: EdgeInsets.only(left: size.width/20, right: size.width/20),
                          child: Text(
                            'Hi my name is Carol and I am a music composer. Music is the greatest passion of my life',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.width/26,
                                color: Colors.grey[500]
                            ),
                          ),
                        ),
                        SizedBox(height: size.height/30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: size.width/3.5,
                              child: RaisedButton(
                                onPressed: (){},
                                color: Colors.red[600],
                                child: Text(
                                    'FOLLOW',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red[600]),
                                ),
                                elevation: 0.0,
                              ),
                            ),
                            ButtonTheme(
                              minWidth: size.width/3.5,
                              child: RaisedButton(
                                onPressed: (){},
                                color: Colors.white,
                                child: Text(
                                    'ADD FRIEND',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red[600],
                                    )
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red[600]),
                                ),
                                elevation: 0.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height/30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                    '373',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                      fontSize: size.width/20,
                                    )
                                ),
                                Text(
                                  'Friends',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontSize: size.width/26,
                                  ),
                                )
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey[400],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                    '15K',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                      fontSize: size.width/20,
                                    )
                                ),
                                Text(
                                  'Followers',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontSize: size.width/26,
                                  ),
                                )
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.grey[400],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                    '3.2K',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                      fontSize: size.width/20,
                                    )
                                ),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontSize: size.width/26,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: size.height/30),
                        Container(
                          margin: EdgeInsets.only(left: size.width/50, right: size.width/50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'My Clubs',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[300]
                                ),
                              ),
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height/50,),
                        Carousel(),
                      ],
                    )

                ),
              ),

              Positioned(
                top: size.height/14,
                left: ((size.width/2)-(size.width/9)),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/Default-female.png'),
                    radius:size.height/18),
              )
            ]
        ),
      ),
    );
  }
}