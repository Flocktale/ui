import 'package:flutter/material.dart';


class Carousel extends StatelessWidget {
  static Color shadow = Color(0xFF191818);
  List<String> myClubs= ['Card1.jpg','Card2.jpg','Card3.jpg','Card4.jpg'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(left: size.width/50, right: size.width/50),
      height: 250,
      child: ListView.builder(
        itemCount: myClubs.length,
        scrollDirection: Axis.horizontal,
       // children: <Widget>[
        itemBuilder: (context,index) {
          return Container(
            width: 200.0,
            child: Card(
              elevation: 10,
              shadowColor: shadow.withOpacity(0.2),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {},
                child: Wrap(
                  children: <Widget>[
                    Image.asset('assets/images/${myClubs[index]}', height: 130,
                      width: 200,
                      fit: BoxFit.cover,),
                    ListTile(
                      title: Text('Rock 101',style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),),
                      subtitle: Text(
                          'An introduction to the world of Rock music.',style: TextStyle(fontFamily: 'Lato',)),

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
