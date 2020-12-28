import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/chopper/user_database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';

class Carousel extends StatefulWidget {
  static Color shadow = Color(0xFF191818);
  String userId;
  Carousel({this.userId});
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<String> myClubs= ['Card1.jpg','Card2.jpg','Card3.jpg','Card4.jpg'];
  BuiltList<BuiltClub> Clubs;

  _fetchAllClubs()async{
    final service = Provider.of<UserDatabaseApiService>(context,listen: false);
    Clubs = (await service.getMyHistoryClubs(widget.userId)).body.clubs;
    print("============LENGTH= ${Clubs.length}");

    //THIS IS RETURNING NULL
 //   setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _fetchAllClubs(),
      builder:(context,snapshot){
        if (Clubs == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(child:CircularProgressIndicator());
        }
        return Container(
        margin: EdgeInsets.only(left: size.width/50, right: size.width/50),
        height: 250,
        child: ListView.builder(
          itemCount: Clubs.length,
          scrollDirection: Axis.horizontal,
         // children: <Widget>[
          itemBuilder: (context,index) {
            return Container(
              width: 200.0,
              child: Card(
                elevation: 10,
                shadowColor: Carousel.shadow.withOpacity(0.2),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {},
                  child: Wrap(
                    children: <Widget>[
                      Image.network(Clubs[index].clubAvatar, height: 130,
                        width: 200,
                        fit: BoxFit.cover,),
                      ListTile(
                        title: Text(Clubs[index].clubName,style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),),
                        subtitle: Text(
                          Clubs[index].description!=null?
                          Clubs[index].description:
                            '',style: TextStyle(fontFamily: 'Lato',)),

                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );}
    );
  }
}
