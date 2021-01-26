import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mootclub_app/pages/ProfilePage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';

class ClubPage extends StatefulWidget {
  // BuiltList<BuiltClub> Clubs;
  BuiltClub Club;
  ClubPage({this.Club});
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final _commentController = TextEditingController();
  String newComment;
  double time = 20;
  // bool 

  
  @override
  void initState() {
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
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
                        /*  gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end:
                            Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                            colors: [
                              const Color(0xff5286ff),
                              const Color(0xff3a64c7)
                              //  const Color(0xffd90000)
                            ], // red to yellow
                            //tileMode: TileMode.repeated, // repeats the gradient over the canvas
                          ),*/
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
                          child: Image.network(widget.Club.clubAvatar,fit: BoxFit.cover,),
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
                              widget.Club.clubName,
                            style: TextStyle(
                              color: Color(0xFF354075),
                              fontFamily: 'Lato',
                              fontSize: size.width/15,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.Club.creator.username,
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
                      Positioned(
                        top: 50,
                        left: 15,
                        child: Container(
                          height: size.height/2.5,
                          width: size.width-30,
                          color: Colors.white
                        )
                      ),
                      Positioned(
                        left: 20,
                        bottom: 30,
                        child: Row(
                            children: [
                              Container(
                                height: 40,
                                width: size.width/1.25,
                                child: TextField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[200],
                                      hintText: 'Comment',
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                          borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlue, width: 2.0))),
                                  controller: _commentController,
                                  onChanged: (val) => newComment = val,
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  _commentController.text = '';
                      //            _sendComment(context);
                                },
                              ),
                            ],
                          ),)
                    ]
                    )
                ),
                SizedBox(height: size.height / 10),
                Container(
                  margin: EdgeInsets.only(
                      left: size.width / 50,
                      right: size.width / 50),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Suggested for you',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF354075)),
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
                Container(
                  height: size.height/20,
            /*      child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ListTile(
                        leading: Image.asset('assets/Card1.jpg',height: size.height/50,width: size.width/20,),
                        title: Text('Rock 101'),
                      ),
                      ListTile(
                        leading: Image.asset('assets/Card2.jpg',height: size.height/50,width: size.width/20,),
                        title: Text('Jazz 101')
                      ),
                      ListTile(
                          leading: Image.asset('assets/Card3.jpg',height: size.height/50,width: size.width/20,),
                          title: Text('Jazz 101')
                      ),
                      ListTile(
                          leading: Image.asset('assets/Card4.jpg',height: size.height/50,width: size.width/20,),
                          title: Text('Jazz 101')
                      ),
                    ],
                  ),*/
                )
              ],
            ),
          ),
        )
    )
    );
  }
}
