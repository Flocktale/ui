import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/AppBarWidget.dart';
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

  _fetchAllClubs() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    Clubs = (await service.getAllClubs(authorization: authToken))
        .body
        .categoryClubs;
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
              AppBarWidget(),
              SizedBox(
                height: 20,
              ),
              /* Text(
                    'Join your \nfavourite clubs.',
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: size.width/10
                    ),
                  ),*/
              SizedBox(
                width: 250.0,
                child: TypewriterAnimatedTextKit(
                  isRepeatingAnimation: false,
                  speed: const Duration(milliseconds: 125),
                  onTap: () {
                    print("Tap Event");
                  },
                  text: [
                    'Join your \nfavourite clubs.',
                  ],
                  textStyle: TextStyle(
                      fontSize: 30.0,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _fetchAllClubs(),
                    builder: (context, snapshot) {
                      if (Clubs == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        //  return Center(child: CircularProgressIndicator());
                        return Container();
                      }
                      return ListView.builder(
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
                          });
                    }),
              ),
              SizedBox(height: size.height/10,)
            ],
        ),
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
