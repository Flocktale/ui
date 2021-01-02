import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootclub_app/Models/built_post.dart';



class FollowersPage extends StatefulWidget {
  int initpos;
  BuiltUser user;
  FollowersPage({this.initpos,this.user});
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  List<String> tabs = ['Friends','Followers','Following'];
  Widget searchBar(String hint){
    return Container(
      height: 40,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.black,),
          fillColor: Colors.grey[200],
          hintText: 'Search ${hint}',
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.black,width: 1.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0)
          )
        ),
      ),
    );
  }
  Widget tabPage(int index){
    List<BuiltUser> userList = [widget.user,widget.user,widget.user,];
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        searchBar(tabs[index]),
        SizedBox(height: 40,),
        Text(
          'All ${tabs[index]}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
      SizedBox(height: 30,),
      ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 7,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context,ind){
            return Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.avatar,),
                    radius: 30,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                          widget.user.username,
                          style: TextStyle(
                            fontFamily: 'Lato',
                          ),
                      ),
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Colors.grey[700]
                        ),
                      )
                    ],
                  ),
                  InkWell(
                    child: Container(
                      width: 100,
                      height: 35,
                      child: Center(
                        child: Text(
                          index==0? 'Remove Friend':index==1? 'Remove':'Following'
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[700]),
                        borderRadius: BorderRadius.circular(12)
                      ),
                    ),
                  )
                ],
              ),
            );
      })
      //  ListView.builder(),//To be filled with get results.
      ],
    );
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
   return DefaultTabController(
     initialIndex: widget.initpos,
     length: tabs.length,
     child: Scaffold(
       appBar: AppBar(
         iconTheme: IconThemeData(
           color: Colors.black
         ),
         backgroundColor: Colors.grey[100],
         title: Text(widget.user.username,style: TextStyle(color: Colors.black,fontFamily: 'Lato',fontWeight: FontWeight.bold),),
         bottom: TabBar(
           isScrollable: true,
           unselectedLabelColor: Colors.grey[700],
           labelColor: Colors.black,
           labelStyle: TextStyle(
             fontFamily: 'Lato',
             fontWeight: FontWeight.bold
           ),
           indicator: UnderlineTabIndicator(
             borderSide: BorderSide(color: Colors.black),
           ),
           indicatorSize: TabBarIndicatorSize.tab,
           tabs: List<Widget>.generate(tabs.length, (index) => Tab(text: tabs[index],)),
         ),
       ),
       body: TabBarView(
           children: [
             tabPage(0),
             tabPage(1),
             tabPage(2)
           ]),
     ),
   );
  }
}
