import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';

class AudiencePage extends StatefulWidget {
  BuiltClub club;
  AudiencePage({this.club});
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  bool _isSearching = false;
  Map<String, dynamic> relationMap = {
    'data': null,
    'isLoading': true,
  };
  Map<String, dynamic> searchResultMap = {
    'data': null,
    'isLoading': true,
  };

  Widget _audienceListWidget(){
    final relationUsers = (relationMap['data'] as BuiltSearchUsers)?.users;
    final bool isLoading = relationMap['isLoading'];
    final listLength = (relationUsers?.length ?? 0) + 1;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
        //  _fetchMoreRelationData();
          relationMap['isLoading'] = true;
        }
        return true;
      },
      child: ListView.builder(
        itemCount: listLength,
          itemBuilder: (context,index){
            if (index == listLength - 1) {
              if (isLoading)
                return Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Center(child: CircularProgressIndicator()),
                );
              else
                return Container();
            }
            return Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ListView(

              ),
            );

      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Audience",
          style: TextStyle(
            fontFamily: "Lato",
            color: Colors.black
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: _isSearching
            ? Center(child: CircularProgressIndicator())
            : _audienceListWidget(),
      ),
    );
  }
}
