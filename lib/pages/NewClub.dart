import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import '../MinClub.dart';
import 'ImagePage.dart';

class NewClub extends StatefulWidget {
  final String userId;
  NewClub({this.userId});
  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String description;
  String category;
  List categoryList = [
    'Entrepreneurship',
    'Education',
    'Comedy',
    'Travel',
    'Society',
    'Health',
    'Finance',
    'Sports',
    'Other'
  ];

  _createClub() async {
    if (name == null ||
        name.isEmpty ||
        description == null ||
        description.isEmpty ||
        category == null ||
        category.isEmpty) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return;
    }

    print('sending');

    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final newClub = BuiltClub((b) => b
      ..clubName = name
      ..description = description
      ..category = category);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final resp = await service.createNewClub(newClub, widget.userId,
        authorization: authToken);
    print('=========' + resp.body);
    print(resp.error);
   
    Fluttertoast.showToast(msg: 'club entry is created');
  }

  Widget _buildName() {
    return TextFormField(
      onTap: () {},
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
        focusColor: Colors.red,
      ),
      validator: (value) {
        if (value.isEmpty) return 'Required';
        if (value.length<3) return 'Minimum Length should be 3';
        if (value.length>25) return 'Maximum Length should be 25';


        return null;
      },
      onSaved: (String value) {
        name = value;
      },
    );
  }

  Widget _buildDescription() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(
          fontFamily: 'Lato',
        ),
        border: OutlineInputBorder(),
      ),
      maxLength: 100,
      maxLines: 3,
      onChanged: (String value) {
        description = value;
      },
    );
  }

  Widget _buildCategory() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton(
        hint: Text('Select Category'),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down),
        underline: SizedBox(),
        isExpanded: true,
        style: TextStyle(
          fontFamily: 'Lato',
          color: Colors.black,
        ),
        value: category,
        onChanged: (newValue) {
          setState(() {
            category = newValue;
          });
        },
        items: categoryList.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Container(
                margin: EdgeInsets.only(left: 10), child: Text(valueItem)),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
          margin: EdgeInsets.only(left: size.width / 50, right: size.width / 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: size.height / 50),
              Text(
                'Create a new club',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                  fontSize: size.height / 25,
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildName(),
                      SizedBox(
                        height: size.height / 50,
                      ),
                      _buildDescription(),
                      SizedBox(
                        height: size.height / 50,
                      ),
                      _buildCategory(),
                      SizedBox(
                        height: size.height / 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonTheme(
                            minWidth: size.width / 3.5,
                            child: RaisedButton(
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                } else {
                                  _formKey.currentState.save();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ImagePage(
                                            name: name,
                                            description: description,
                                            category: category,
                                            userId: widget.userId,
                                          )));
                                }
                              },
                              color: Colors.white,
                              child: Text('Select an image',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                    fontFamily: 'Lato',
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                //side: BorderSide(color: Colors.red[600]),
                              ),
                            ),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                                fontFamily: 'Lato', fontWeight: FontWeight.bold),
                          ),
                          ButtonTheme(
                            minWidth: size.width / 3.5,
                            child: RaisedButton(
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                } else {
                                  _formKey.currentState.save();
                                  print(name);
                                  print(description);
                                  print(category);
//                                Navigator.of(context).pushNamed('/imagePage');
                                  _createClub();
                                }
                              },
                              color: Colors.red[600],
                              child: Text('Skip and Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                  )),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                //side: BorderSide(color: Colors.red[600]),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
          Positioned(
              bottom:0,
              child: MinClub())
        ]
      ),
    ));
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
