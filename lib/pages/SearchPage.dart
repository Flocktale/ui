import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Text(
            'Search',
            style: TextStyle(
              fontSize: size.width/20,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold
            ),
          ),
          TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }
}
