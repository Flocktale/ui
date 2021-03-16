import 'package:flocktale/customImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:built_collection/built_collection.dart';
import 'ProfilePage.dart';

class BlockedUsersPage extends StatefulWidget {
  BuiltClub club;
  BlockedUsersPage({this.club});
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {

  BuiltList<AudienceData> blockedUsers;
  bool isLoading = true;
  Future<void> _fetchBlockedUsersData() async {
    final authToken = (Provider.of<UserData>(context, listen: false).authToken);
    blockedUsers =
        (await Provider.of<DatabaseApiService>(context, listen: false)
                .getAllBlockedUsers(
                    clubId: widget.club.clubId, authorization: authToken))
            .body;
    isLoading = false;
    setState(() {});
  }


  Widget audienceList() {
    final size = MediaQuery.of(context).size;
    final listLength = blockedUsers.length;
    return listLength==0?
        Center(
          child: Text(
              "No blocked users",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.grey
            ),
          ),
        ):
    Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView.builder(
              itemCount: listLength,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final _user = blockedUsers[index].audience;
                return Container(
                  key: ValueKey(_user.username),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: CustomImage(
                        image: _user.avatar + "_thumb",
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
                    trailing: widget.club.creator.userId == _user.userId
                        ? ButtonTheme(
                            minWidth: size.width / 3.5,
                            child: RaisedButton(
                              onPressed: () async {
                                final authToken = Provider.of<UserData>(context,
                                        listen: false)
                                    .authToken;
                                final resp =
                                    (await Provider.of<DatabaseApiService>(
                                            context,
                                            listen: false)
                                        .unblockUser(
                                            clubId: widget.club.clubId,
                                            audienceId: _user.userId,
                                            authorization: authToken));
                                if (resp.isSuccessful) {
                                  Fluttertoast.showToast(msg: 'User unblocked');
                                  blockedUsers = blockedUsers
                                      .rebuild((b) => b.removeAt(index));
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Something went wrong');
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
                          )
                        : SizedBox(
                            width: 0,
                          ),
                  ),
                );
              }),
    );
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
        body: isLoading?
              Center(
                child: Container(
                  child: CircularProgressIndicator()
                ),
              ):
              audienceList(),
      ),
    );
  }
}
