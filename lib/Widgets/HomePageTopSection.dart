import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageTopSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function navigateTo;

  const HomePageTopSection({
    Key key,
    this.scaffoldKey,
    this.navigateTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cuser = Provider.of<UserData>(context, listen: false).user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => scaffoldKey.currentState.openDrawer(),
          child: Container(
            width: 36,
            height: 36,
            child: CustomImage(
              image: cuser.avatar,
              radius: 8,
            ),
          ),
        ),
        Text(
          'Flocktale',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontSize: 18,
            letterSpacing: 1,
            fontFamily: 'Montserrat',
          ),
        ),
        IconButton(
          onPressed: () {
            if (navigateTo != null) {
              navigateTo(NotificationPage());
            }
          },
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}
