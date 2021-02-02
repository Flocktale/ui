import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/Club.dart';
import 'package:built_collection/built_collection.dart';

class Carousel extends StatefulWidget {
  final Color shadow = Color(0xFF191818);
  final BuiltList<BuiltClub> Clubs;
  Carousel({this.Clubs});
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<String> myClubs = ['Card1.jpg', 'Card2.jpg', 'Card3.jpg', 'Card4.jpg'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: size.width / 50, right: size.width / 50),
    //  height: 250,
      height: 185,
      child: ListView.builder(
        itemCount: widget.Clubs.length,
        scrollDirection: Axis.horizontal,
        // children: <Widget>[
        itemBuilder: (context, index) {
          return Container(
            //width: 200.0,
            width: 150,
            child: Card(
              elevation: 10,
              shadowColor: widget.shadow.withOpacity(0.2),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => Club(club: widget.Clubs[index])));
                },
                child: Wrap(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Center(
                        child: Image.network(
                          widget.Clubs[index].clubAvatar,
                //      height: 130,
                //      width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        widget.Clubs[index].clubName,
                        style: TextStyle(
                            fontFamily: 'Lato', fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                        Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                backgroundImage: NetworkImage(widget.Clubs[index].creator.avatar),
                                radius: 10,
                              ),
                                SizedBox(width: 5,),

                                Text(
                                  widget.Clubs[index].creator.username,
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.redAccent
                                ),
                              ),]
                            ),
                       Container(
                         margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("12.1K LISTENERS",style: TextStyle(
                               fontFamily: "Lato",
                               fontSize: size.width/50,
                               color: Colors.grey
                             ),),
                             Container(
                                color: Colors.red,
                                alignment: Alignment(1, 1),
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  "LIVE",
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                    fontSize: size.width/50
                                  ),
                                ),
                              ),
                           ],
                         ),
                       ),
                          ],
                        ),
//                      trailing:  Container(
//                        color: Colors.red,
//                        child: Text(
//                          "LIVE",
//                          style: TextStyle(
//                              fontFamily: 'Lato',
//                              fontWeight: FontWeight.bold,
//                              color: Colors.white,
//                              letterSpacing: 2.0,
//                            fontSize: 10
//                          ),
//                        ),
//                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
