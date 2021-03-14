import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
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

  inviteAudience(String userId) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final cuser = Provider.of<UserData>(context, listen: false).user;
    var inviteeList = new BuiltList<String>([userId]);
    BuiltInviteFormat invite = BuiltInviteFormat((b) => b
      ..type = 'participant'
      ..invitee = inviteeList.toBuilder());
    final resp = (await service.inviteUsers(
        clubId: widget.club.clubId,
        sponsorId: cuser.userId,
        invite: invite,
        authorization: authToken));
    if (resp.isSuccessful)
      Fluttertoast.showToast(msg: 'User Invited');
    else
      Fluttertoast.showToast(msg: 'Some Error Occurred');
  }

  Widget audienceList() {
    final size = MediaQuery.of(context).size;
    var audienceListUsers =
        (audienceMap['data'] as BuiltAudienceList)?.audience;
    final bool isLoading = audienceMap['isLoading'];
    final listLength = (audienceListUsers?.length ?? 0) + 1;
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

                final _user = audienceListUsers[index]?.audience;
                print("User= ${_user}");
                return _user != null
                    ? Container(
                        key: ValueKey(_user.username),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: FadeInImage.assetNetwork(
                              image: _user.avatar + "_thumb",
                              placeholder: 'assets/gifs/fading_lines.gif',
                              imageErrorBuilder: (context, _, __) =>
                                  Image.asset('assets/images/logo.ico'),
                            ),
                          ),
                          title: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => ProfilePage(
                                        userId: _user.userId,
                                      )));
                            },
                            child: Text(
                              _user.username != null ? _user.username : "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold),
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
                          trailing: widget.club.creator.userId == _user.userId
                              ? FittedBox(
                                  child: Row(
                                    children: [
                                      ButtonTheme(
                                          child: RaisedButton(
                                        onPressed: () async {
                                          inviteAudience(_user.userId);
                                          setState(() {});
                                        },
                                        color: Colors.white,
                                        child: Text(
                                          "Invite to speak",
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.w200),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            side: BorderSide(
                                                color: Colors.red[600])),
                                      )),
                                      ButtonTheme(
                                        child: RaisedButton(
                                          onPressed: () async {
                                            final authToken =
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .authToken;
                                            final resp = (await Provider.of<
                                                        DatabaseApiService>(
                                                    context,
                                                    listen: false)
                                                .blockAudience(
                                                    clubId: widget.club.clubId,
                                                    audienceId: _user.userId,
                                                    authorization: authToken));
                                            if (resp.isSuccessful) {
                                              Fluttertoast.showToast(
                                                  msg: 'User blocked');
                                              audienceListUsers =
                                                  audienceListUsers.rebuild(
                                                      (b) =>
                                                          b..removeAt(index));
                                              setState(() {});
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: 'Something went wrong');
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
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            //side: BorderSide(color: Colors.red[600]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: 0,
                                ),
                        ),
                      )
                    : Container();
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
