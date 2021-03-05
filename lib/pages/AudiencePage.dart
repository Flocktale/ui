import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';

class AudiencePage extends StatefulWidget {
  BuiltClub club;
  AudiencePage({this.club});
  @override
  _AudiencePageState createState() => _AudiencePageState();
}

class _AudiencePageState extends State<AudiencePage> {
  Map<String, dynamic> audienceMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchAudienceData() async {
    final authToken = (Provider.of<UserData>(context, listen: false).authToken);
    audienceMap['data'] =
        (await Provider.of<DatabaseApiService>(context, listen: false)
                .getAudienceList(
                    clubId: widget.club.clubId,
                    lastevaluatedkey: (audienceMap['data'] as BuiltAudienceList)
                        ?.lastevaluatedkey,
                    authorization: authToken))
            .body;
    audienceMap['isLoading'] = false;
    setState(() {});
  }

  void _fetchMoreAudienceData() async {
    if (audienceMap['isLoading'] == true) return;
    setState(() {});

    final lastEvaluatedKey =
        (audienceMap['data'] as BuiltAudienceList)?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchAudienceData();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      audienceMap['isLoading'] = false;
    }
    setState(() {});
  }

  Widget audienceList() {
    final size = MediaQuery.of(context).size;
    final audienceListUsers =
        (audienceMap['data'] as BuiltAudienceList)?.audience;
    final bool isLoading = audienceMap['isLoading'];
    final listLength = (audienceListUsers?.length ?? 0) + 1;
    final _user = Provider.of<UserData>(context,listen: false).user;
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _fetchMoreAudienceData();
              audienceMap['isLoading'] = true;
            }
            return true;
          },
          child: ListView.builder(
              itemCount: listLength,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == listLength - 1) {
                  if (isLoading)
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  else
                    return Container();
                }

                final _user = audienceListUsers[index].audience;

                return Container(
                  key: ValueKey(_user.username),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_user.avatar),
                    ),
                    title: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfilePage(
                                  userId: _user.userId,
                                )));
                      },
                      child: Text(
                        _user.username,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Lato', fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfilePage(
                                  userId: _user.userId,
                                )));
                      },
                      child: Text(
                        _user.tagline != null ? '@${_user.tagline}' : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    trailing:
                        widget.club.creator.userId == _user.userId?
                    ButtonTheme(
                      minWidth: size.width / 3.5,
                      child: RaisedButton(
                        onPressed: () async {
                          final authToken =
                              Provider.of<UserData>(context, listen: false)
                                  .authToken;
                          final resp = (await Provider.of<DatabaseApiService>(
                                  context,
                                  listen: false)
                              .blockAudience(
                                  clubId: widget.club.clubId,
                                  audienceId: _user.userId,
                                  authorization: authToken));
                          if (resp.isSuccessful) {
                            setState(() {});
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else {
                            Fluttertoast.showToast(msg: 'Something went wrong');
                          }
                        },
                        color: Colors.red[600],
                        child: Text('Kick Out',
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
                    ):SizedBox(width: 0,),
                  ),
                );
              }),
        ));
  }

  @override
  void initState() {
    super.initState();
    _fetchAudienceData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Audience",
              style: TextStyle(
                  fontFamily: "Lato",
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
        body: audienceList(),
      ),
    );
  }
}
