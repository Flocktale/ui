import 'package:flutter/material.dart';

class ClubAudience extends StatefulWidget {
  @override
  _ClubAudienceState createState() => _ClubAudienceState();
}

class _ClubAudienceState extends State<ClubAudience> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Audience',
            style: TextStyle(
              fontFamily: 'Lato',
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: ListView.builder(
              itemBuilder: (context,index){
                return Container(
                  child: ListTile(
                  ),
                );
              })
        ),
      ),
    );
  }
}
