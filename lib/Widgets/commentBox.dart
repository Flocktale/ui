import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flocktale/Widgets/profileSummary.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  final Size size;
  final List<Comment> comments;
  final ScrollController listController;

  final Function(Widget) navigateTo;
  final Function(int, int) processTimestamp;
  final Function(String) addComment;

  final TextEditingController newCommentController;

  CommentBox({
    this.size,
    this.comments,
    this.listController,
    this.navigateTo,
    this.processTimestamp,
    this.addComment,
    this.newCommentController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: size.width,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: comments.length,
                  controller: listController,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    bool continuation = false;
                    if (index != comments.length - 1) {
                      if (comment.user.userId ==
                          comments[index + 1].user.userId) continuation = true;
                    }

                    return Container(
                      margin: EdgeInsets.only(
                          bottom: continuation ? 0 : 12, right: 32, top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          continuation
                              ? SizedBox(width: 36)
                              : Container(
                                  height: 36,
                                  width: 36,
                                  child: GestureDetector(
                                    onTap: () {
                                      ProfileShortView.display(
                                          context, comment.user);
                                    },
                                    child: CustomImage(
                                      image: comment.user.avatar + "_thumb",
                                      radius: 8,
                                    ),
                                  ),
                                ),
                          SizedBox(width: 8),
                          Flexible(
                              child: Card(
                            elevation: 1,
                            shadowColor: Colors.redAccent,
                            color: Colors.black,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.body,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${continuation ? "" : comment.user.username} · ${processTimestamp(comment.timestamp, 1)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            width: size.width,
            child: TextField(
              controller: newCommentController,
              minLines: 1,
              maxLines: 3,
              cursorColor: Colors.redAccent,
              scrollPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              textInputAction: TextInputAction.newline,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    addComment(newCommentController.text);

                    newCommentController.text = '';
                  },
                ),
                hintStyle: TextStyle(color: Colors.white38),
                fillColor: Colors.white10,
                hintText: "Type what's in your mind",
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white12, width: 0.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.white12, width: 0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
