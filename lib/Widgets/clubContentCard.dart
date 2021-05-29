import 'package:date_time_picker/date_time_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flutter/material.dart';

class ClubContentCard extends StatelessWidget {
  final ClubContentModel data;
  final String placeHolderContentImage;

  const ClubContentCard(
    this.data, {
    this.placeHolderContentImage = 'assets/images/news.png',
  });

  @override
  Widget build(BuildContext context) {
    String time = '';
    if (data.timestamp != null) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(data.timestamp);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final diff = today.difference(dateTime).inDays;

      if (diff == 0)
        time = DateFormat.jm().format(dateTime);
      else if (diff == 1)
        time = 'yesterday';
      else
        time = '$diff days ago';
    }

    return Card(
      elevation: 2,
      shadowColor: Color(0xfff74040),
      color: Colors.white,
      child: Container(
        height: 108,
        color: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 120,
              child: data.avatar == null
                  ? Image.asset(placeHolderContentImage)
                  : FadeInImage.assetNetwork(
                      fit: BoxFit.contain,
                      placeholder: 'assets/gifs/fading_lines.gif',
                      image: data.avatar,
                      imageErrorBuilder: (ctx, _, __) {
                        return Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.fill,
                        );
                      },
                    ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      data.title ?? '-',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          child: Text(
                            '- ' + data.source,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Flexible(
                          flex: 2,
                          child: Text(
                            time,
                            style: TextStyle(color: Colors.white54),
                          )),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
