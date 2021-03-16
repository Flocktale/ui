import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../MinClub.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'ClubDetail.dart';
import 'package:image_cropper/image_cropper.dart';

class NewClub extends StatefulWidget {
  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String description;
  String category;
  String subCategory;
  String scheduleDate;
  bool scheduleClub = false;
  TextEditingController _controller1;
  List<String> categoryList = [];
  File image;
  List<String> subCategoryList = [];
  final picker = ImagePicker();

  getImage() async {
    final selectedImage = await picker.getImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: selectedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          maxHeight: 400,
          maxWidth: 400,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              statusBarColor: Colors.redAccent,
              cropFrameColor: Colors.grey[600],
              backgroundColor: Colors.white,
              toolbarColor: Colors.white));
      setState(() {
        if (croppedImage != null) {
          image = File(croppedImage.path);
        } else {
          print("Picture not selected.");
        }
      });
    }
  }

  BuiltClub get _newClubModel {
    if (name?.isNotEmpty != true ||
        description?.isNotEmpty != true ||
        category?.isNotEmpty != true ||
        subCategory?.isNotEmpty != true) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return null;
    }
    var parsedDate =
        DateTime.parse(scheduleDate ?? DateTime.now().toIso8601String());

    int scheduleDateTime = parsedDate.millisecondsSinceEpoch;
    return BuiltClub((b) => b
      ..clubName = name
      ..description = description
      ..category = category
      ..subCategory = subCategory
      ..scheduleTime = scheduleDateTime);
  }

  _createClub() async {
    if (_newClubModel == null) return;

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;

    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final resp = await service.createNewClub(
      body: _newClubModel,
      creatorId: userId,
      authorization: authToken,
    );
    if (resp.isSuccessful && image != null) {
      String imageInBase64;
      if (image != null) {
        var pickedImage = await image.readAsBytes();
        imageInBase64 = base64Encode(pickedImage);
        final newImage = BuiltProfileImage((b) => b..image = imageInBase64);
        final response = await service.updateClubAvatar(
          clubId: resp.body['clubId'],
          image: newImage,
          authorization: authToken,
        );
        print("!!!!!!!!!!!!!!!!!!!!!!!");
        print(response.isSuccessful);
        BuiltClub newClub = (await service.getClubByClubId(
          userId: userId,
          clubId: resp.body['clubId'],
          authorization: authToken,
        ))
            .body
            ?.club;
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (_) => ClubDetailPage(
                      club: newClub,
                    )))
            .then((value) => () {
                  _formKey.currentState.reset();
                  image = null;
                  setState(() {});
                });
        Fluttertoast.showToast(msg: 'club entry is created');
      }
    } else {
      print('=========${resp.body}');
      print(resp.error);
      Fluttertoast.showToast(msg: 'club entry is created');
      BuiltClub tempClub = (await service.getClubByClubId(
        userId: userId,
        clubId: resp.body['clubId'],
        authorization: authToken,
      ))
          .body
          ?.club;
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (_) => ClubDetailPage(
                    club: tempClub,
                  )))
          .then((value) => () {
                _formKey.currentState.reset();
                image = null;
                setState(() {});
              });
      _formKey.currentState.reset();
      setState(() {
        image = null;
      });
    }
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
      maxLines: 2,
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

  Widget dateTimePicker() {
    return DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      controller: _controller1,
      //initialValue: _initialValue,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      icon: Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      use24HourFormat: true,
      onSaved: (val) {
        setState(() {
          scheduleDate = val;
        });
      },
    );
  }

  Widget _scheduleClub() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Schedule for later",
          style: TextStyle(
            fontFamily: "Lato",
          ),
        ),
        Switch(
          activeColor: Colors.red,
          value: scheduleClub,
          onChanged: (val) {
            if (val) {
              scheduleClub = true;
            } else {
              scheduleClub = false;
            }
            setState(() {});
          },
        )
      ],
    );
  }

  void _initCategoryData() async {
    final userData = Provider.of<UserData>(context, listen: false);

    if (userData.categoryData == null) {
      final service = Provider.of<DatabaseApiService>(context, listen: false);
      final authToken = userData.authToken;
      final resp = await service.getCategoryData(authorization: authToken);

      if (resp.isSuccessful) {
        userData.categoryData = (resp.body as Map).map((k, v) => MapEntry(
            k as String, (v as List).map((e) => e as String).toList()));
      }
    }
    categoryList = userData.categoryData['categories'];
    subCategoryList = userData.categoryData[categoryList.first];

    setState(() {});
  }

  _showMaterialDialog() {
    BuiltClub activeClub =
        Provider.of<AgoraController>(context, listen: false).club;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Please end the club \"${activeClub.clubName}\" before entering another club."),
            actions: [
              FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Ok",
                  style: TextStyle(
                      fontFamily: "Lato",
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => ClubDetailPage(
                            club: activeClub,
                          )));
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _initCategoryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    super.build(context);
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
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
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, size.height / 500, 0, 0),
                    child: GestureDetector(
                      onTap: getImage,
                      behavior: HitTestBehavior.deferToChild,
                      child: Container(
                        height: size.height / 6,
                        width: size.width / 3,
                        color: Colors.red,
                        child: Container(
                          height: size.height / 6,
                          width: size.width / 3,
                          child: image == null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: size.height / 20,
                                    ),
                                    Icon(
                                      Icons.add_a_photo,
                                      size: size.width / 15,
                                      color: Colors.black,
                                      semanticLabel: "Add a photo",
                                    ),
                                    Text(
                                      "Add a club avatar",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                )
                              : Stack(
                                  children: [
                                    Image.file(image),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          image = null;
                                          setState(() {});
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Icon(
                                            Icons.cancel,
                                            color: Colors.black,
                                            size: size.width / 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                        _scheduleClub(),
                        scheduleClub ? dateTimePicker() : Container(),
                        SizedBox(
                          height: size.height / 30,
                        ),
                        ButtonTheme(
                          minWidth: size.width / 3.5,
                          child: RaisedButton(
                            onPressed: () {
                              if (club != null &&
                                  club.creator.userId == cuserId) {
                                _showMaterialDialog();
                              } else {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                } else {
                                  _formKey.currentState.save();
                                  print(name);
                                  print(description);
                                  print(category);
                                  _createClub();
                                }
                              }
                            },
                            color: Colors.red[600],
                            child: Text('Submit',
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
                        )
                      ],
                    ))
              ],
            ),
          ),
          Positioned(bottom: 0, child: MinClub())
        ]),
      )),
    );
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
