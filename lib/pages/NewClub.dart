import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import '../MinClub.dart';
import 'Club.dart';
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
  String subCategory;
  List<String> categoryList = [];

  List<String> subCategoryList = [];

  BuiltClub get _newClubModel {
    if (name?.isNotEmpty != true ||
        description?.isNotEmpty != true ||
        category?.isNotEmpty != true ||
        subCategory?.isNotEmpty != true) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return null;
    }
    return BuiltClub((b) => b
      ..clubName = name
      ..description = description
      ..category = category
      ..subCategory = subCategory);
  }

  _createClub() async {
    if (_newClubModel == null) return;

    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final resp = await service.createNewClub(
      body: _newClubModel,
      creatorId: widget.userId,
      authorization: authToken,
    );
    Fluttertoast.showToast(msg: 'club entry is created');
    BuiltClub tempClub = (await service.getClubByClubId(
      userId: widget.userId,
      clubId: resp.body['clubId'],
      authorization: authToken,
    ))
        .body
        ?.club;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Club(
              club: tempClub,
            )));

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
        if (value.length < 3) return 'Minimum Length should be 3';
        if (value.length > 25) return 'Maximum Length should be 25';

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

  Widget _dropDownWidget(
          {String hint,
          Function(String) onChanged,
          String value,
          List<String> itemList}) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButton(
          hint: Text(hint ?? 'Select Category'),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down),
          underline: SizedBox(),
          isExpanded: true,
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.black,
          ),
          value: value,
          onChanged: onChanged,
          items: itemList.map((valueItem) {
            return DropdownMenuItem(
              value: valueItem,
              child: Container(
                  margin: EdgeInsets.only(left: 10), child: Text(valueItem)),
            );
          }).toList(),
        ),
      );

  Widget _buildCategory() {
    return _dropDownWidget(
        hint: 'Select Category',
        onChanged: (newValue) {
          category = newValue;

          subCategoryList = Provider.of<UserData>(context, listen: false)
              .categoryData[category];

          subCategory = null;

          setState(() {});
        },
        value: category,
        itemList: categoryList ?? []);
  }

  Widget _buildSubCategory() {
    return _dropDownWidget(
        hint: 'Select Sub-Category',
        onChanged: (newValue) {
          setState(() {
            subCategory = newValue;
          });
        },
        value: subCategory,
        itemList: subCategoryList ?? []);
  }

  void _initCategoryData() async {
    final userData = Provider.of<UserData>(context, listen: false);

    if (userData.categoryData == null) {
      final service = Provider.of<DatabaseApiService>(context, listen: false);
      final authToken = userData.authToken;
      final resp = await service.getCategoryData(authorization: authToken);

      if (resp.isSuccessful) {
        userData.categoryData = (resp.body as Map)
            .map((k, v) => MapEntry(k as String, v as List<String>));
      }
    }
    categoryList = userData.categoryData['categories'];
    subCategoryList = userData.categoryData[categoryList.first];

    setState(() {});
  }

  @override
  void initState() {
    _initCategoryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Container(
          margin:
              EdgeInsets.only(left: size.width / 50, right: size.width / 50),
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
                      _buildSubCategory(),
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

                                  if (_newClubModel == null) return;

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ImagePage(
                                            newClub: _newClubModel,
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
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold),
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
        Positioned(bottom: 0, child: MinClub())
      ]),
    ));
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
