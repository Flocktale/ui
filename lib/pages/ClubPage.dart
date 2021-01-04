import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';

class ClubPage extends StatefulWidget {
  BuiltList<BuiltClub> Clubs;
  int index;
  ClubPage({this.Clubs, this.index});
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  double time = 20;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
//      child: Stack(alignment: Alignment.center, children: <Widget>[
//        Positioned(
//          top: 10,
//          left: size.width / 50,
//          right: size.width / 50,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.arrow_back),
//                color: Colors.redAccent,
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//              Text(
//                'Now Playing',
//                style: TextStyle(
//                    fontFamily: 'Lato',
//                    fontWeight: FontWeight.bold,
//                    letterSpacing: 2.0,
//                    color: Colors.redAccent),
//              ),
//            ],
//          ),
//        ), //App Bar
//        Positioned(
//          top: size.height / 8,
//          left: (size.width / 4),
//          child: Image.network(
//            widget.Clubs[widget.index].clubAvatar,
//            height: size.height / 4,
//            width: size.width / 2,
//            fit: BoxFit.cover,
//          ),
//        ), //Club Image
//        Positioned(
//          top: size.height / 8,
//          right: 10,
//          child: Column(
//            children: <Widget>[
//              LikeButton(
//                likeBuilder: (bool isLiked) {
//                  return Icon(
//                    Icons.favorite,
//                    color: isLiked ? Colors.redAccent : Colors.grey,
//                    size: size.height / 22.5,
//                  );
//                },
//              ),
//              SizedBox(
//                height: size.height / 50,
//              ),
//              IconButton(
//                icon: Icon(
//                  Icons.share,
//                  color: Colors.green,
//                ),
//                iconSize: size.height / 22.5,
//              ),
//              SizedBox(
//                height: size.height / 50,
//              ),
//              InkWell(
//                onTap: () {
//                  Navigator.of(context).push(MaterialPageRoute(
//                      builder: (_) => ProfilePage(
//                          userId: widget.Clubs[widget.index].creator.userId)));
//                },
//                child: CircleAvatar(
//                  backgroundColor: Colors.white,
//                  backgroundImage:
//                      NetworkImage(widget.Clubs[widget.index].creator.avatar),
//                  radius: size.height / 45,
//                ),
//              ),
//              SizedBox(
//                height: size.height / 50,
//              ),
//              LikeButton(
//                circleColor: CircleColor(start: Colors.grey, end: Colors.black),
//                bubblesColor: BubblesColor(
//                  dotPrimaryColor: Colors.black,
//                  dotSecondaryColor: Colors.grey,
//                ),
//                likeBuilder: (bool isLiked) {
//                  return Icon(
//                    Icons.flag,
//                    color: isLiked ? Colors.black : Colors.grey,
//                    size: size.height / 22.5,
//                  );
//                },
//              )
//            ],
//          ),
//        ), //Side column
//        Positioned(
//          top: (size.height / 2.5) + (size.height / 50),
//          child: Column(
//            children: <Widget>[
//              Text(
//                widget.Clubs[widget.index].clubName,
//                style: TextStyle(
//                  fontFamily: 'Lato',
//                  fontWeight: FontWeight.bold,
//                  fontSize: size.width / 15,
//                ),
//              ),
//              SizedBox(
//                height: size.height / 100,
//              ),
//              Text(
//                'By @${widget.Clubs[widget.index].creator.username}',
//                style: TextStyle(fontFamily: 'Lato', color: Colors.grey),
//              )
//            ],
//          ),
//        ), //Club Name
//        Positioned(
//            top: (size.height / 2.5) + (5 * size.height / 50),
//            child: Container(
//              width: size.width,
//              child: Slider(
//                activeColor: Colors.amber,
//                inactiveColor: Colors.grey[300],
//                value: time,
//                onChanged: (newTime) {
//                  setState(() {
//                    time = newTime;
//                  });
//                },
//                min: 0.0,
//                max: 100.0,
//              ),
//            )), //Seek Bar
//        Positioned(
//          top: (size.height / 2.5) + (7 * size.height / 50),
//          left: size.width / 30,
//          right: size.width / 30,
//          child: Container(
//            width: size.width,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text(
//                  '0:00',
//                  style: TextStyle(fontFamily: 'Lato', color: Colors.black),
//                ),
//                Text(
//                  '15:30',
//                  style: TextStyle(fontFamily: 'Lato', color: Colors.black),
//                )
//              ],
//            ),
//          ),
//        ), //Seek Bar Times
//        Positioned(
//          top: (size.height / 2.5) + (7 * size.height / 50),
//          child: Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.skip_previous),
//                  iconSize: size.height / 20,
//                  disabledColor: Colors.redAccent,
//                ),
//                IconButton(
//                  icon: Icon(Icons.play_circle_filled),
//                  iconSize: size.height / 10,
//                  disabledColor: Colors.amber,
//                  splashColor: Colors.amberAccent,
//                ),
//                IconButton(
//                  icon: Icon(Icons.skip_next),
//                  iconSize: size.height / 20,
//                  disabledColor: Colors.redAccent,
//                )
//              ],
//            ),
//          ),
//        ), //Play Button
//        Positioned(
//          top: (size.height / 2.5) + (15 * size.height / 50),
//          child: Column(children: <Widget>[
//            Text('Panelists',
//                style: TextStyle(
//                    fontFamily: 'Lato',
//                    fontSize: size.width / 20,
//                    fontWeight: FontWeight.bold,
//                    color: Colors.redAccent)),
//            SizedBox(height: size.height / 50),
//            Container(
//              height: 64,
//              width: size.width,
//              child: ListView.builder(
//                scrollDirection: Axis.horizontal,
//                itemCount: 10,
//                itemBuilder: (ctx, index) {
//                  return Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                    child: CircleAvatar(
//                      backgroundColor: Colors.orange.withOpacity(0.3),
//                      radius: 32,
//                      child: Icon(
//                        Icons.person_outline,
//                        size: 30,
//                        color: Colors.black,
//                      ),
//                    ),
//                  );
//                },
//              ),
//            ),
//          ]),
//        ), //Listener
//        Positioned(
//          top: size.height - 80,
//          left: 10,
//          right: 10,
//          child: Container(
//              height: size.height,
//              width: size.width,
//              decoration: BoxDecoration(
//                color: Colors.redAccent,
//                borderRadius: BorderRadius.circular(18),
//              ),
//              child: Stack(children: <Widget>[
//                Positioned(
//                  top: 15,
//                  left: 10,
//                  child: Text(
//                    'COMMENTS',
//                    style: TextStyle(
//                        fontFamily: 'Lato',
//                        fontWeight: FontWeight.bold,
//                        color: Colors.white,
//                        fontSize: size.width / 25,
//                        letterSpacing: 2.0),
//                  ),
//                )
//              ])),
//        )
//      ]),
        child: Scaffold(
          appBar: AppBar(
           // leading: Icon(Icons.arrow_back),
            title: Text('Now Playing',style: TextStyle(fontFamily: 'Lato',fontWeight: FontWeight.bold,color: Colors.white),),
            backgroundColor: Colors.lightBlue,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Column(

              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: size.height/4,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(size.width/2.5, size.height/10))
                      ),
                    ),
                    Positioned(
                      child: Center(
                        child: Container(
                          height: size.height / 4,
                          width: size.width / 2,
                          margin: EdgeInsets.fromLTRB(0, size.height/16, 0, 0),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25.0, // soften the shadow
                                  spreadRadius: 5.0, //extend the shadow
                                  offset: Offset(
                                    0.0,
                                    15.0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ],
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          child: Image.network(widget.Clubs[widget.index].clubAvatar,fit: BoxFit.cover,),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: size.height/20),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.share,color: Color(0xFF354075),size: size.height / 25),
                      Column(
                        children: <Widget>[
                          Text(
                              widget.Clubs[widget.index].clubName,
                            style: TextStyle(
                              color: Color(0xFF354075),
                              fontFamily: 'Lato',
                              fontSize: size.width/15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.Clubs[widget.index].creator.username,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Lato',
                              fontSize: size.width/20,
                            ),
                          ),
                        ],
                      ),
                    LikeButton(
                    likeBuilder: (bool isLiked) {
                      return isLiked?Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: size.height / 25,
                      ):
                      Icon(
                        Icons.favorite_border_rounded,
                        color: Color(0xFF354075),
                        size: size.height / 25,
                      );
                    },
                  ),
                    ],
                  ),
                ),
                SizedBox(height: size.height/30,),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 30,
                        left:15,
                        child: Text(
                          '0:00',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    Container(
                      width: size.width,
                    child: Slider(
                      activeColor: Color(0xFF354075),
                      inactiveColor: Colors.grey[300],
                      value: time,
                      onChanged: (newTime) {
                        setState(() {
                          time = newTime;
                        });
                      },
                      min: 0.0,
                      max: 100.0,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 15,
                    child: Text(
                      '15:30',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                    ],
                  ),
                ),
                //SizedBox(height: size.height/30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.skip_previous,color: Color(0xFF354075),), onPressed: null,iconSize: size.height/22.5,),
                    IconButton(icon: Icon(Icons.play_circle_filled,color: Colors.lightBlue,), onPressed: null,iconSize: size.height / 10),
                    IconButton(icon: Icon(Icons.skip_next,color: Color(0xFF354075),), onPressed: null,iconSize: size.height / 22.5),
                  ],
                ),
                SizedBox(height: size.height/30,),
                Text('Panelists',
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF354075))),
                  SizedBox(height: size.height / 50),
                  Container(
                      height: 64,
                      width: size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.orange.withOpacity(0.3),
                              radius: 32,
                              child: Icon(
                                Icons.person_outline,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                SizedBox(height: size.height / 30),
                Container(
                    height: size.height/2,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(children: <Widget>[
                      Positioned(
                        top: 15,
                        left: 10,
                        child: Text(
                          'COMMENTS',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: size.width / 25,
                              letterSpacing: 2.0),
                        ),
                      ),
                      
                    ]
                    )
                )
              ],
            ),
          ),
        )
    )
    );
  }
}
