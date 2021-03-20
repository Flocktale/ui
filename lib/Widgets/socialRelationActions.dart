import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/LocalStorage/FollowingDatabase.dart';
import 'package:flocktale/services/LocalStorage/InviteBox.dart';
import 'package:flocktale/services/socialInteraction.dart';
import 'package:flutter/material.dart';

class SocialRelationActions extends StatelessWidget {
  final SocialInteraction _socialInteraction;
  final RelationIndexObject _userRelations;
  final Size size;
  final String foreignUsername;

  const SocialRelationActions(this._socialInteraction, this._userRelations,
      this.size, this.foreignUsername);

  Widget actionButton(
      {String text,
      Function onPressed,
      Color buttonColor,
      Color textColor,
      FontWeight fontWeight = FontWeight.normal}) {
    return ButtonTheme(
      minWidth: size.width / 3.5,
      child: RaisedButton(
        onPressed: () => onPressed(),
        color: buttonColor,
        child: Text(text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontFamily: 'Lato',
            )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(color: Colors.red[600]),
        ),
      ),
    );
  }

  Widget friendRequestActions() {
    return Container(
        width: size.width,
        child: Column(
          children: [
            Text(
              "$foreignUsername has sent you a friend request",
              style: TextStyle(
                fontFamily: "Lato",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                actionButton(
                  text: 'Accept',
                  onPressed: () async =>
                      await _socialInteraction.acceptFriendRequest(),
                  buttonColor: Colors.red[600],
                  textColor: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                actionButton(
                  text: 'Decline',
                  onPressed: () async =>
                      await _socialInteraction.cancelFriendRequest(),
                  buttonColor: Colors.white,
                  textColor: Colors.redAccent,
                ),
              ],
            )
          ],
        ));
  }

  Widget relationActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        actionButton(
          text: _userRelations.B5 == false ? 'Follow' : 'Following',
          onPressed: () async {
            if (_userRelations.B5 == false) {
              FollowingDatabase.addFollowing(_socialInteraction.userId);
              await _socialInteraction.sendFollow();
            } else {
              FollowingDatabase.deleteFollowing(_socialInteraction.userId);
              await _socialInteraction.sendUnFollow();
            }
          },
          buttonColor:
              _userRelations.B5 == false ? Colors.red[600] : Colors.white,
          textColor:
              _userRelations.B5 == false ? Colors.white : Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
        actionButton(
          text: _userRelations.B1 == true
              ? "FRIENDS"
              : _userRelations.B3 == false
                  ? "Add Friend"
                  : "Request Sent",
          onPressed: () async {
            if (_userRelations.B1 == true) {
              await _socialInteraction.unFriend();
            } else if (_userRelations.B3 == false) {
              await _socialInteraction.sendFriendRequest();
            } else {
              await _socialInteraction.cancelFriendRequest();
            }
          },
          buttonColor: Colors.white,
          textColor: _userRelations.B1 == true
              ? Colors.red
              : _userRelations.B3 == false
                  ? Colors.black
                  : Colors.black38,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userRelations == null
        ? Container(
            height: size.height / 20,
            child: Center(
              child: Text(
                "Loading...",
                style: TextStyle(fontFamily: "Lato", color: Colors.black38),
              ),
            ),
          )
        : _userRelations.B2 == true
            ? friendRequestActions()
            : relationActions();
  }
}
