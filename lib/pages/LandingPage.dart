import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Carousel.dart';
import 'package:mootclub_app/MinClub.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with AutomaticKeepAliveClientMixin {
  BuiltList<CategoryClubsList> Clubs;
  List<String> Category = [
    'Entrepreneurship',
    'Education',
    'Comedy',
    'Travel',
    'Society',
    'Health',
    'Finance',
    'Sports',
    'Other'
  ];

  BuiltNotificationList notificationList;
  bool hasNewNotifications = false;
  Future getNotifications() async{
    final service = Provider.of<DatabaseApiService>(context,listen: false);
    final cuser = Provider.of<UserData>(context,listen:false).user;
    final authToken = Provider.of<UserData>(context,listen:false).authToken;
    String lastEvalustedKey;
    BuiltNotificationList tempNotificationList =  (await service.getNotifications(cuser.userId, lastEvalustedKey, authorization: authToken)).body;
    if(notificationList!=null && tempNotificationList.notifications.length>notificationList.notifications.length)
      hasNewNotifications = true;
    notificationList = tempNotificationList;
  }
 Future _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    Clubs = (await service.getAllClubs(authorization: authToken))
        .body
        .categoryClubs;
    await getNotifications();
    setState(() {
    });
  }

  @override
  void initState(){
    _fetchAllClubs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body: Stack(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.camera_alt_outlined), onPressed: null),
                        Text(
                          'MOOTCLUB',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        IconButton(
                          icon: hasNewNotifications==false?Icon(Icons.notifications_none_outlined):Icon(Icons.notifications_active,color: Colors.redAccent,),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/notificationPage');
                          },
                        ),
                      ],
                    ),
//                        SizedBox(
//                          height: 20,
//                        ),
//                        SizedBox(
//                          width: 250.0,
//                          child: TypewriterAnimatedTextKit(
//                            isRepeatingAnimation: false,
//                            speed: const Duration(milliseconds: 125),
//                            onTap: () {
//                              print("Tap Event");
//                            },
//                            text: [
//                              'Join your \nfavourite clubs.',
//                            ],
//                            textStyle: TextStyle(
//                                fontSize: 30.0,
//                                fontFamily: "Lato",
//                                fontWeight: FontWeight.w300,
//                                color: Colors.black),
//                            textAlign: TextAlign.start,
//                          ),
//                        ),
                        RefreshIndicator(
                          onRefresh: _fetchAllClubs,
                          child: Container(
                            height: size.height-157,
                            child: Clubs!=null?
                            ListView.builder(
                                itemCount: Category.length,
                                itemBuilder: (context, index) {
                                  return Clubs[index].clubs.isNotEmpty
                                      ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: size.height / 30),
                                      Text(
                                        Clubs[index].category,
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.w400,
                                          fontSize: size.width / 15,
                                        ),
                                      ),
                                      SizedBox(height: size.height / 50),
                                      Carousel(Clubs: Clubs[index].clubs),
                                    ],
                                  )
                                      : Container();
                                }):
                            Container(
                              child: Center(
                                  child: Text(
                                    "Loading...",
                                    style: TextStyle(
                                        fontFamily: "Lato",
                                        color: Colors.grey
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ),
                        //  SizedBox(height: size.height/10,)
                      ],
                    )
                ),
                Positioned(
                    bottom:0,
                    child: MinClub())

              ]
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
