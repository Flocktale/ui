import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../pages/NewsPage.dart';
class NewsTab extends StatefulWidget {
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<ClubContentModel> contentList;
  DatabaseApiService service;

  Future<void> _fetchContentList() async {
    contentList = (await service.getContentData(type: 'news'))?.body?.toList();
    setState(() {});
  }

  @override
  void initState() {
    service = Provider.of<DatabaseApiService>(context, listen: false);
    _fetchContentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (contentList == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        final data = contentList[index];

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

        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>NewsPage(
              news: data,
            )));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              elevation: 2,
              shadowColor: Color(0xfff74040),
              child: Container(
                height: 108,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 120,
                      // color: Colors.blue,
                      child: data.avatar == null
                          ? Image.asset('assets/images/news.png')
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
                      // color: Colors.red,
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
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Flexible(flex: 2, child: Text(time)),
                            ],
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
