import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';

class ClubJoinRequests extends StatefulWidget {
  BuiltClub club;
  ClubJoinRequests({this.club});
  @override
  _ClubJoinRequestsState createState() => _ClubJoinRequestsState();
}

class _ClubJoinRequestsState extends State<ClubJoinRequests> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Requests',
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView.builder(itemBuilder: (context,index){
          return Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/Card1.jpg'),
              ),
              title: Text("Listener ${index}",
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text("@Username${index}",
              style: TextStyle(
                fontFamily: 'Lato'
              ),),
              trailing: ButtonTheme(
                minWidth: size.width / 3.5,
                child: RaisedButton(
                  onPressed: () {
                  },
                  color: Colors.red[600],
                  child: Text('Accept',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    //side: BorderSide(color: Colors.red[600]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ));
  }
}
