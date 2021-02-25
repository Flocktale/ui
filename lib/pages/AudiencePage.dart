import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'ProfilePage.dart';
class AudiencePage extends StatefulWidget {
  BuiltClub club;
  AudiencePage({this.club});
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  bool _isSearching = false;
  Map<String, dynamic> audienceMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchAudienceData() async{
    final service = Provider.of<DatabaseApiService>(context,listen:false);
    final authToken = Provider.of<UserData>(context,listen: false).authToken;
    audienceMap['data'] = await service.getAudienceList(clubId: widget.club.clubId, lastevaluatedkey: (audienceMap['data'] as BuiltSearchUsers)?.lastevaluatedkey, authorization: authToken);
    audienceMap['isLoading'] = false;
    setState(() {
    });
  }

  Future<void> _fetchMoreAudienceData() async{
    if(audienceMap['isLoading']==true)
      return;
    setState(() {
    });
    final lastEvaluatedKey = (audienceMap['data'] as BuiltSearchUsers)?.lastevaluatedkey;
    if(lastEvaluatedKey!=null){
      await _fetchAudienceData();
    }
    else{
      await Future.delayed(Duration(milliseconds: 200));
      audienceMap['isLoading'] = false;
    }
    setState(() {
    });
  }

  Widget _audienceListWidget(){
    final audienceUsers = (audienceMap['data'] as BuiltSearchUsers)?.users;
    final bool isLoading = audienceMap['isLoading'];
    final listLength = (audienceUsers?.length ?? 0) + 1;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          audienceMap['isLoading'] = true;
          _fetchMoreAudienceData();
        }
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
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
            final _user = audienceUsers[index];
            return Container(
              key: ValueKey(_user.username),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_user.avatar),
                ),
                title: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>ProfilePage(userId: _user.userId,)));
                  },
                  child: Text(
                    _user.username,
                    style: TextStyle(
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ),
            );

      }),
    );
  }
  @override
  void initState() {
    _fetchAudienceData();
    super.initState();
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
      body: _audienceListWidget(),
    );
  }
}
