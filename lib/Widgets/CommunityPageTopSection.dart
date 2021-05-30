import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';

class CommunityPageTopSection extends StatelessWidget {
  final BuiltCommunity community;
  final bool isMember;

  final Function toggleIsMember;

  CommunityPageTopSection(
    this.community, {
    this.isMember,
    this.toggleIsMember,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.width * 9 / 16,
      width: size.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                constraints: constraints,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(community.coverImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38,
                      Colors.black38,
                      Colors.black54,
                      Colors.black54,
                      Colors.black54,
                      Colors.black87,
                      Colors.black,
                    ],
                    stops: [0.1, 0.2, 0.3, 0.4, 0.5, 0.7, 1],
                  ),
                ),
              ),
              Container(
                constraints: constraints,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          child: CustomImage(
                            image: community.avatar,
                            radius: 8,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              community.name,
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                  fontSize: 16),
                            ),
                            Text(
                              community.creator.username,
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isMember != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isMember ? "Member" : "JOIN",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 4),
                              InkWell(
                                onTap: () => toggleIsMember(),
                                child: isMember
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 24,
                                      )
                                    : Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              ),
                            ],
                          ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline,
                                color: Colors.white70, size: 18),
                            SizedBox(width: 8),
                            Text(
                              '${community.memberCount ?? 0}',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
