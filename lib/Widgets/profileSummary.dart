import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flocktale/services/socialInteraction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProfileShortView extends StatefulWidget {
  final SummaryUser summaryUser;
  final ScrollController controller;
  const ProfileShortView(this.summaryUser, this.controller);
  @override
  _ProfileShortViewState createState() => _ProfileShortViewState();
}

class _ProfileShortViewState extends State<ProfileShortView> {
  BuiltUser _user;
  RelationIndexObject _userRelations;

  bool _isMe = false;

  bool _isFetching = true;
  bool _isLoading = false;

  Future _fetchUser() async {
    final cuser = Provider.of<UserData>(context, listen: false).user;

    if (cuser.userId == widget.summaryUser.userId) {
      _isMe = true;
      _user = cuser;
      setState(() {
        _isFetching = false;
      });
      return;
    }

    this._user = BuiltUser(
      (b) => b
        ..userId = widget.summaryUser.userId
        ..username = widget.summaryUser.username
        ..avatar = widget.summaryUser.avatar,
    );
    setState(() {});

    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final profileData = (await service.getUserProfile(
      userId: widget.summaryUser.userId,
      primaryUserId: cuser.userId,
    ))
        .body;

    _user = profileData.user;
    _userRelations = profileData.relationIndexObj;
    _isFetching = false;

    if (_user.userId == null) {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
    }
    setState(() {});
  }

  void _updateProfileFromResponse(
      RelationActionResponse relationActionResponse) {
    if (relationActionResponse == null) return;
    _userRelations = relationActionResponse.relationIndexObj;

    _user = _user.rebuild((b) => b
      ..followerCount =
          relationActionResponse.followerCount ?? _user.followerCount
      ..followingCount =
          relationActionResponse.followingCount ?? _user.followingCount
      ..friendsCount =
          relationActionResponse.friendsCount ?? _user.friendsCount);

    setState(() {});
  }

  @override
  void initState() {
    _fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: topSection,
          ),
          Expanded(
            child: ListView(
              controller: widget.controller,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      child: CustomImage(
                        image: _user.avatar + '_large',
                        pinwheelPlaceholder: true,
                        radius: 8,
                      ),
                    ),
                    if (_isFetching)
                      Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ))
                    else
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  socialCounts(_user.friendsCount, 'Friends'),
                                  socialCounts(
                                      _user.followerCount, 'Followers'),
                                  socialCounts(
                                      _user.followingCount, 'Following'),
                                ],
                              ),
                              if (_isMe == false) SizedBox(height: 12),
                              if (_isMe == false)
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 32),
                                        decoration: BoxDecoration(
                                          color: _userRelations.B5
                                              ? Colors.black.withOpacity(0.7)
                                              : Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            final socialInteraction =
                                                SocialInteraction(context,
                                                    widget.summaryUser.userId,
                                                    updateProfileFromResponse:
                                                        _updateProfileFromResponse);
                                            if (_userRelations.B5) {
                                              await socialInteraction
                                                  .sendUnFollow();
                                            } else {
                                              await socialInteraction
                                                  .sendFollow();
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Text(
                                              _userRelations.B5
                                                  ? 'Following'
                                                  : 'Follow',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                if (_isFetching == false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      if ((_user.tagline ?? "").isNotEmpty)
                        Row(
                          children: [
                            Container(
                              height: 32,
                              child: VerticalDivider(
                                thickness: 2,
                                width: 12,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _user.tagline,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      Text(
                        _user.bio ?? "",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get topSection => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            widget.summaryUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) =>
                          ProfilePage(userId: widget.summaryUser.userId)))
                  .then((_) => Navigator.of(context).pop());
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Text(
                      'Full Profile',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          )
        ],
      );

  Widget socialCounts(int count, String text) => Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      );
}
