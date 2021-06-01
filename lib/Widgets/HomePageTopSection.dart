import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/NotificationPage.dart';
import 'package:flocktale/pages/SearchPages/SearchPage.dart';
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

    return Card(
      color: Colors.black,
      // shadowColor: Colors.white,
      // elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => scaffoldKey.currentState.openDrawer(),
            child: Container(
              width: 40,
              height: 40,
              child: CustomImage(
                image: cuser.avatar,
                radius: 8,
              ),
            ),
          ),
          // this sized box is used to align below text in center
          SizedBox(),
          Text(
            'Flocktale',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              fontSize: 22,
              letterSpacing: 1,
              fontFamily: 'Lato',
            ),
          ),
          Container(
            // color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    if (navigateTo != null) {
                      navigateTo(SearchPage());
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
