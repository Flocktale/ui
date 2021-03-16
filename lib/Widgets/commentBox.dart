import 'package:flocktale/Models/comment.dart';
import 'package:flocktale/customImage.dart';
import 'package:flocktale/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  final Size size;
  final List<Comment> comments;
  final ScrollController listController;

  final Function(Widget) navigateTo;
  final Function(int, int) processTimestamp;
  final Function(String) addComment;

  CommentBox({
    this.size,
    this.comments,
    this.listController,
    this.navigateTo,
    this.processTimestamp,
    this.addComment,
  });

  final TextEditingController newCommentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height / 2 + size.height / 30,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(0),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 15,
            left: 10,
            child: Text(
              'COMMENTS',
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: size.width / 25,
                  letterSpacing: 2.0),
            ),
          ),
          Positioned(
            top: 45,
            left: 10,
            child: Column(
              children: [
                Container(
                  height: size.height / 2.5,
                  width: size.width - 20,
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: comments.length,
                      controller: listController,
                      itemBuilder: (context, index) {
                        var a = ListTile(
                          leading: CircleAvatar(
                            child: CustomImage(
                              image: comments[index].user.avatar + "_thumb",
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
                                      fontFamily: "Lato",
                                      color: Colors.redAccent),
                                ),
                              ),
                              Text(
                                processTimestamp(comments[index].timestamp, 1),
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: size.width / 30),
                              )
                            ],
                          ),
                          subtitle: Text(
                            comments[index].body,
                            style: TextStyle(fontFamily: "Lato"),
                          ),
                        );
                        return a;
                      }),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: size.width - 20,
                  child: TextField(
                    controller: newCommentController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            addComment(newCommentController.text);

                            newCommentController.text = '';
                          },
                        ),
                        fillColor: Colors.white,
                        hintText: 'Comment',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            borderSide:
                                BorderSide(color: Colors.black12, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0))),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}