import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';

class BlockedUsersPage extends StatefulWidget {
  BuiltClub club;
  BlockedUsersPage({this.club});
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  Map<String, dynamic> blockedUsersMap = {
    'data': null,
    'isLoading': true,
  };

  Future<void> _fetchBlockedUsersData() async {
    final authToken = (Provider.of<UserData>(context, listen: false).authToken);
    blockedUsersMap['data'] =
        (await Provider.of<DatabaseApiService>(context, listen: false)
            .getAllBlockedUsers(
            clubId: widget.club.clubId,
            authorization: authToken))
            .body;
    blockedUsersMap['isLoading'] = false;
    setState(() {});
  }

  void _fetchMoreBlockedUserData() async {
    if (blockedUsersMap['isLoading'] == true) return;
    setState(() {});
    final lastEvaluatedKey =
        (blockedUsersMap['data'] as BuiltActiveJoinRequests)?.lastevaluatedkey;

    if (lastEvaluatedKey != null) {
      await _fetchBlockedUsersData();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      blockedUsersMap['isLoading'] = false;
    }
    setState(() {});
  }

  Widget audienceList() {
    final size = MediaQuery.of(context).size;
    var blockedUsersList =
        (blockedUsersMap['data'] as BuiltActiveJoinRequests)?.activeJoinRequestUsers;
    final bool isLoading = blockedUsersMap['isLoading'];
    final listLength = (blockedUsersList?.length ?? 0) + 1;
    final _user = Provider.of<UserData>(context,listen: false).user;
    return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              _fetchMoreBlockedUserData();
              blockedUsersMap['isLoading'] = true;
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

                final _user = blockedUsersList[index].audience;

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
                              .unblockUser(
                              clubId: widget.club.clubId,
                              audienceId: _user.userId,
                              authorization: authToken));
                          if (resp.isSuccessful) {
                            Fluttertoast.showToast(msg: 'User unblocked');
                            blockedUsersList = blockedUsersList.rebuild((b) => b.removeAt(index));
                            setState(() {});
                          } else {
                            Fluttertoast.showToast(msg: 'Something went wrong');
                          }
                        },
                        color: Colors.red[600],
                        child: Text('Unblock',
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
    _fetchBlockedUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              "Blocked Users",
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
