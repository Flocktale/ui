import 'package:built_value/built_value.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:built_collection/built_collection.dart';

class InviteScreen extends StatefulWidget {
  final BuiltClub club;
  final sponsorId;

  /// set [forPanelist] to true only when inviting panelist.
  final bool forPanelist;
  const InviteScreen(
      {@required this.club,
      @required this.sponsorId,
      this.forPanelist = false});
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String type;

  // it retains list of followers, even if user is searching
  // when user clear his/her searches, it will show already loaded data.
  Map<String, dynamic> relationMap = {
    'data': null,
    'isLoading': true,
  };

  // it would be null when user is not searching.
  Map<String, dynamic> searchResultMap = {
    'data': null,
    'isLoading': true,
  };

  bool _isSearching = false;

  bool _isInviting = false;

  Map<String, bool> _selectedUserIds = {};

  Future<void> _fetchRelationData() async {
    relationMap['data'] = (await Provider.of<DatabaseApiService>(context,
                listen: false)
            .getRelations(widget.club.creator.userId, type,
                (relationMap['data'] as BuiltSearchUsers)?.lastevaluatedkey))
        .body;
    relationMap['isLoading'] = false;
    setState(() {});
  }

  void _fetchMoreRelationData() async {
    if (relationMap['isLoading'] == true) return;
    setState(() {});

    final lastevaulatedkey =
        (relationMap['data'] as BuiltSearchUsers)?.lastevaluatedkey;

    if (lastevaulatedkey != null) {
      await _fetchRelationData();
    } else {
      await Future.delayed(Duration(milliseconds: 200));
      relationMap['isLoading'] = false;
    }

    setState(() {});
  }

  Future<void> _inviteUsers({bool all = false}) async {
    if (all == false && _selectedUserIds.isEmpty) {
      Fluttertoast.showToast(msg: 'Select one atleast');
      return;
    }
    setState(() {
      _isInviting = true;
    });

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    Response response;
    if (all) {
      response = await service.inviteAllFollowers(
          widget.club.clubId, widget.sponsorId,
          authorization: authToken);
    } else {
      BuiltList<String> list = BuiltList<String>([]);
      var builder = list.toBuilder();
      builder.addAll(_selectedUserIds.keys);
      response = await service.inviteUsers(
          widget.club.clubId,
          widget.sponsorId,
          BuiltInviteFormat((b) => b
            ..invitee = builder
            ..type = widget.forPanelist ? 'participant' : 'audience'),
          authorization: authToken);
    }
    if (response.isSuccessful) {
      Fluttertoast.showToast(msg: 'Invitations sent successfully');
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: 'Error in sending invitaions');

      setState(() {
        _isInviting = false;
      });
    }
  }

  Widget _relationListWidget() {
    final size = MediaQuery.of(context).size;

    final relationUsers = (relationMap['data'] as BuiltSearchUsers)?.users;

    final bool isLoading = relationMap['isLoading'];

    final listLength = (relationUsers?.length ?? 0) + 1;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _fetchMoreRelationData();
          relationMap['isLoading'] = true;
        }
        return true;
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listLength,
        itemBuilder: (context, index) {
// last index of this list is being used for loading animation while more users are loaded.
          if (index == listLength - 1) {
            if (isLoading)
              return Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Center(child: CircularProgressIndicator()),
              );
            else
              return Container();
          }

          final _user = relationUsers[index];

          return Container(
            key: ValueKey(_user.username),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_user.avatar),
              ),
              title: Text(
                _user.username,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
              trailing: Transform.scale(
                scale: 1.25,
                child: Switch(
                  activeColor: Colors.red[600],
                  value: _selectedUserIds[_user.userId] ?? false,
                  onChanged: (val) async {
                    if (val) {
                      _selectedUserIds[_user.userId] = true;
                    } else {
                      _selectedUserIds.remove(_user.userId);
                    }
                    if (!this.mounted) return;
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _inviteButton(String text, VoidCallback onTap) {
    final size = MediaQuery.of(context).size;

    return ButtonTheme(
      minWidth: size.width / 3.2,
      child: RaisedButton(
        onPressed: onTap,
        color: Colors.red[600],
        child: Text(text,
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
    );
  }

  @override
  void initState() {
    this.type = widget.forPanelist ? 'friends' : 'followers';
    super.initState();
    _fetchRelationData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Invite ' + (widget.forPanelist ? 'Panelist' : 'Audience'),
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: _isInviting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  _isSearching
                      ? Container()
                      : Expanded(child: _relationListWidget()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// Invite all is only for audience type of invitation
                      if (widget.forPanelist == false)
                        _inviteButton(
                            'Invite All', () => _inviteUsers(all: true)),

                      _inviteButton('Invite (${_selectedUserIds.length})',
                          () => _inviteUsers(all: false)),
                    ],
                  )
                ],
              ),
      ),
    ));
  }
}
