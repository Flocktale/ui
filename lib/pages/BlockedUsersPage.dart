import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/ProfileShortView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  final BuiltClub club;
  BlockedUsersPage({this.club});
  @override
  _BlockedUsersPageState createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  List<AudienceData> _blockedUsers;
  bool _isLoading = true;

  DatabaseApiService _service;

  Future<void> loadingCycle(Function function) async {
    setState(() {
      _isLoading = true;
    });

    if (function != null) await function();

    setState(() {
      _isLoading = false;
    });
  }

  unblockUser(SummaryUser user) async {
    await loadingCycle(() async {
      await _service.unblockUser(
        clubId: widget.club.clubId,
        audienceId: user.userId,
      );
      Fluttertoast.showToast(msg: "Unblocked ${user.username}");
    });
  }

  Future<void> _fetchBlockedUsers() async {
    await loadingCycle(() async {
      _blockedUsers =
          (await Provider.of<DatabaseApiService>(context, listen: false)
                  .getAllBlockedUsers(
        clubId: widget.club.clubId,
      ))
              .body
              ?.toList();
    });
  }

  Card get unblockCard => Card(
        color: Colors.white,
        shadowColor: Colors.redAccent,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Unblock',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );

  Widget blockList() {
    final listLength = _blockedUsers.length;

    if (listLength == 0)
      return Center(
        child: Text(
          'No Users...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );

    return ListView.builder(
        shrinkWrap: true,
        itemCount: listLength,
        itemBuilder: (context, index) {
          final _user = _blockedUsers[index].audience;

          return Container(
            key: ValueKey(_user.username + ' $index'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => ProfileShortView.display(context, _user),
                  child: Container(
                    width: 36,
                    height: 36,
                    child: CustomImage(
                      image: _user.avatar + "_thumb",
                      radius: 8,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _user.username,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await unblockUser(_user);

                    _blockedUsers.removeAt(index);

                    setState(() {});
                  },
                  child: unblockCard,
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    this._service = Provider.of<DatabaseApiService>(context, listen: false);
    _fetchBlockedUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
        child: Column(
          children: [
            Text(
              'Blocked Users',
              style: TextStyle(color: Colors.redAccent, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: SpinKitThreeBounce(color: Colors.redAccent),
                    )
                  : blockList(),
            ),
          ],
        ),
      ),
    );
  }
}
