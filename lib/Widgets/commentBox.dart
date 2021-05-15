import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/Widgets/customImage.dart';
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
                    var a = ListTile(
                      leading: CircleAvatar(
                        child: CustomImage(
                          image: comments[index].user.avatar + "_thumb",
                          radius: 8,
                        ),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => navigateTo(
                              ProfilePage(
                                userId: comments[index].user.userId,
                              ),
                            ),
                            child: Text(
                              comments[index].user.username,
                              style: TextStyle(
                                  fontFamily: "Lato", color: Colors.redAccent),
                            ),
                          ),
                          Text(
                            processTimestamp(comments[index].timestamp, 1),
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: size.width / 30,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      subtitle: Text(
                        comments[index].body,
                        style: TextStyle(
                          fontFamily: "Lato",
                          color: Colors.white,
                        ),
                      ),
                    );
                    return a;
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
