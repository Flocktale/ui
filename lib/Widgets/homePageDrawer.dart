import 'package:flocktale/Authentication/logOut.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/pages/ContactsPage.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flocktale/pages/settings.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/shareApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageDrawer extends StatelessWidget {
  Widget _bottomPanel(BuildContext context) {
    final bottomButtonCard = ({
      String title,
      Function onTap,
      Color contentColor,
      IconData icon,
    }) =>
        InkWell(
          onTap: () => (onTap ?? () {})(),
          splashColor: Colors.redAccent,
          child: Card(
            color: Colors.black,
            shadowColor: Colors.white,
            elevation: 0.2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: contentColor,
                  ),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(color: contentColor, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          bottomButtonCard(
            title: "Settings",
            icon: Icons.settings,
            contentColor: Colors.white,
            onTap: () => _navigateTo(SettingsPage(), context),
          ),
          SizedBox(height: 16),
          bottomButtonCard(
            title: "Log Out",
            icon: Icons.logout,
            contentColor: Colors.redAccent,
            onTap: () async {
              await logOutUser(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerButtons({
    String title,
    Function onTap,
    IconData suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: InkWell(
        splashColor: Colors.redAccent,
        onTap: () => (onTap ?? () {})(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Icon(
              suffixIcon,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateTo(Widget page, BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    // no need to listen for changes as name and username and image url are immutable.
    final cuser = Provider.of<UserData>(context, listen: false).user;

    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            right: BorderSide(color: Colors.white54),
            top: BorderSide(color: Colors.white24),
          )),
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                Divider(color: Colors.white70),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        child: CustomImage(
                          image: cuser.avatar,
                          radius: 8,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _navigateTo(
                              ProfilePage(userId: cuser.userId), context);
                        },
                        child: Column(
                          children: [
                            Text(
                              cuser.name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  cuser.username,
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 16),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(color: Colors.white70),
                SizedBox(height: 12),
                _drawerButtons(
                  title: "Create Community",
                  suffixIcon: Icons.add,
                  onTap: () {
                    try {
                      launch(
                          'https://docs.google.com/forms/d/e/1FAIpQLSfRrRTaSJ2_1n3cCSShRYpDmd4FaJqdm50s3wTR69PMHqCHcw/viewform');
                    } catch (e) {}
                  },
                ),
                _drawerButtons(
                  title: "Invite",
                  onTap: () {
                    _navigateTo(ContactsPage(), context);
                  },
                  suffixIcon: Icons.people_outline_sharp,
                ),
                _drawerButtons(
                  title: "Share",
                  onTap: () {
                    ShareApp(context).app();
                  },
                  suffixIcon: Icons.share_outlined,
                ),
              ],
            ),
            _bottomPanel(context),
          ],
        ),
      ),
    );
  }
}
