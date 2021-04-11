import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'ClubDetail.dart';
import 'package:image_cropper/image_cropper.dart';

import 'CommunityPage.dart';

class NewClub extends StatefulWidget {
  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> with TickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _communityFormKey = GlobalKey<FormState>();
  String name;
  String communityName;
  String description;
  String communityDescription;
  String category;
  String subCategory;
  String scheduleDate;
  bool scheduleClub = false;
  bool isLoading = false;
  TextEditingController _controller1;
  List<String> categoryList = [];
  File image;
  File communityCoverImage;
  File communityAvatar;
  List<String> subCategoryList = [];
  TabController _tabController;
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

  getCommunityCoverImage() async {
    Size size = MediaQuery.of(context).size;
    final selectedImage = await picker.getImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: selectedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
          compressQuality: 50,
          maxHeight: (2*size.width~/3),
          maxWidth: size.width~/1,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              statusBarColor: Colors.redAccent,
              cropFrameColor: Colors.grey[600],
              backgroundColor: Colors.white,
              toolbarColor: Colors.white));
      setState(() {
        if (croppedImage != null) {
          communityCoverImage = File(croppedImage.path);
        } else {
          print("Picture not selected.");
        }
      });
    }
  }

  getCommunitiesProfileImage() async {
    final selectedImage = await picker.getImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
          cropStyle: CropStyle.circle,
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
          communityAvatar = File(croppedImage.path);
        } else {
          print("Picture not selected.");
        }
      });
    }
  }

  BuiltClub get _newClubModel {
    if (name?.isNotEmpty != true ||
        description?.isNotEmpty != true ||
        category?.isNotEmpty != true) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return null;
    }
    var parsedDate =
        DateTime.parse(scheduleDate ?? DateTime.now().toIso8601String());

    int scheduleDateTime;
    if (scheduleClub) {
      scheduleDateTime = parsedDate.millisecondsSinceEpoch;
    }
    return BuiltClub((b) => b
      ..clubName = name
      ..description = description
      ..category = category
      ..subCategory = subCategory
      ..scheduleTime = scheduleDateTime);
  }

  BuiltCommunity get _newCommunityModel {
    if (communityName?.isNotEmpty != true ||
        communityDescription?.isNotEmpty != true ) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return null;
    }
    return BuiltCommunity((b) => b
        ..name = communityName
        ..description = communityDescription
      );
  }

  _createClub() async {
    if (_newClubModel == null) return;
    setState(() {
      isLoading = true;
    });
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;

    final resp = await service.createNewClub(
      body: _newClubModel,
      creatorId: userId,
    );
    setState(() {
      isLoading = false;
    });
    if (resp.isSuccessful && image != null) {
      String imageInBase64;
      if (image != null) {
        var pickedImage = await image.readAsBytes();
        imageInBase64 = base64Encode(pickedImage);
        final newImage = BuiltProfileImage((b) => b..image = imageInBase64);
        final response = await service.updateClubAvatar(
          clubId: resp.body['clubId'],
          image: newImage,
        );
        print("!!!!!!!!!!!!!!!!!!!!!!!");
        print(response.isSuccessful);
        BuiltClub newClub = (await service.getClubByClubId(
          userId: userId,
          clubId: resp.body['clubId'],
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
                  setState(() {
                    image = null;
                    isLoading = false;
                  });
                });
        setState(() {
          _formKey.currentState.reset();
          image = null;
          isLoading = false;
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

  _createCommunity() async {
    if (_newCommunityModel == null) return;
    setState(() {
      isLoading = true;
    });
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider
        .of<UserData>(context, listen: false)
        .userId;

    final resp = await service.createCommunity(
      body: _newCommunityModel,
      creatorId: userId,
    );
    setState(() {
      isLoading = false;
    });
    if (resp.isSuccessful && communityAvatar != null) {
      String imageInBase64;
      String communityImage64;
      if (communityCoverImage != null) {
        var pickedAvatar = await communityAvatar.readAsBytes();
        var pickedImage = await communityCoverImage.readAsBytes();
        imageInBase64 = base64Encode(pickedImage);
        communityImage64 = base64Encode(pickedAvatar);
        CommunityImageUploadBody communityImages = CommunityImageUploadBody((
            b) =>
        b
          ..coverImage = imageInBase64
          ..avatar = communityImage64
        );

        final response = await service.uploadCommunityImages(
            resp.body['communityId'],
            body: communityImages
        );
        print("!!!!!!!!!!!!!!!!!!!!!!!");
        print(response.isSuccessful);
        BuiltCommunity newCommunity = (await service.getCommunityByCommunityId(
            resp.body['communityId'],
            userId: userId
        ))
            .body
            ?.community;
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (_) =>
                CommunityPage(
                  community: newCommunity,
                )))
            .then((value) =>
            () {
          _formKey.currentState.reset();
          setState(() {
            communityAvatar = null;
            communityCoverImage = null;
            isLoading = false;
          });
        });
        setState(() {
          _formKey.currentState.reset();
          communityAvatar = null;
          communityCoverImage = null;
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'community entry is created');
      }
    }
    else {
      print('=========${resp.body}');
      print(resp.error);
      Fluttertoast.showToast(msg: 'club entry is created');
      BuiltCommunity newCommunity = (await service.getCommunityByCommunityId(
          resp.body['communityId'],
          userId: userId
      ))
          .body
          ?.community;
      Navigator.of(context)
          .push(MaterialPageRoute(
          builder: (_) =>
              CommunityPage(
                community: newCommunity,
              )))
          .then((value) =>
          () {
        _formKey.currentState.reset();
        setState(() {
          communityAvatar = null;
          communityCoverImage = null;
          isLoading = false;
        });
      });
      setState(() {
        _formKey.currentState.reset();
        communityAvatar = null;
        communityCoverImage = null;
        isLoading = false;
      });
      if (resp.isSuccessful) {
        Fluttertoast.showToast(msg: 'Community created');
      }
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

  Widget _buildCommunityName() {
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
        communityName = value;
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

  Widget _buildCommunityDescription() {
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
        communityDescription = value;
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
      final resp = await service.getCategoryData();

      if (resp.isSuccessful) {
        userData.categoryData = (resp.body as Map).map((k, v) => MapEntry(
            k as String, (v as List).map((e) => e as String).toList()));
      }
    }
    categoryList = userData.categoryData['categories'];
    subCategoryList = userData.categoryData[categoryList.first];

    setState(() {});
  }

  _showMaterialDialog() async {
    BuiltClub activeClub =
        Provider.of<AgoraController>(context, listen: false).club;
    final res = await showDialog(
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
                  Navigator.of(context).pop(false);
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
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
    if (res == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ClubDetailPage(club: activeClub)));
    }
  }

  Widget tabPage(int index){
    Size size = MediaQuery.of(context).size;
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    if(index==0){
      return isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Stack(children: [
              Container(
                margin: EdgeInsets.only(
                    left: size.width / 50, right: size.width / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: size.height / 50),
                    // Text(
                    //   'Create a new club',
                    //   style: TextStyle(
                    //     fontFamily: 'Lato',
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: size.height / 25,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: size.height / 50,
                    // ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0, size.height / 500, 0, 0),
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
                                        fontWeight:
                                        FontWeight.w400),
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
                                        backgroundColor:
                                        Colors.transparent,
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
                      ),
                    )
                  ],
                ),
              ),
          // Positioned(bottom: 0, child: MinClub(null))
        ]),
      );
    }
    return SingleChildScrollView(
      child: Form(
        key: _communityFormKey,
        child: Column(
          children: [
            SizedBox(
              height: size.height/30,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, size.height / 50, 0, 0),
                child: GestureDetector(
                  onTap: getCommunitiesProfileImage,
                  behavior: HitTestBehavior.deferToChild,
                  child: CircleAvatar(
                    radius: size.height / 14.7,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      radius: size.height / 15,
                      backgroundImage:
                      communityAvatar == null ? null : FileImage(communityAvatar),
                      backgroundColor: Colors.white,
                      child: communityAvatar == null
                          ? Icon(
                        Icons.add_a_photo,
                        size: size.width / 15,
                        color: Colors.black,
                      )
                          : Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            communityAvatar = null;
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
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height/30,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    0, size.height / 500, 0, 0),
                child: GestureDetector(
                  onTap: getCommunityCoverImage,
                  behavior: HitTestBehavior.deferToChild,
                  child: Container(
                    height: size.height/6,
                    width: size.width ,
                    color: Colors.red,
                    child: Container(
                      height: size.height/6,
                      width: size.width,
                      child: communityCoverImage == null
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
                            "Add a cover image",
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontWeight:
                                FontWeight.w400),
                          )
                        ],
                      )
                          : Stack(
                        children: [
                          Image.file(communityCoverImage,fit: BoxFit.fill,),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                communityCoverImage = null;
                                setState(() {});
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                Colors.transparent,
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
              height: size.height/30 + size.height/50,
            ),
            _buildCommunityName(),
            SizedBox(
              height: size.height/50,
            ),
            _buildCommunityDescription(),
            SizedBox(
              height: size.height/50,
            ),
            ButtonTheme(
              minWidth: size.width / 3.5,
              child: RaisedButton(
                onPressed: () {

                    if (!_communityFormKey.currentState.validate()) {
                      return;
                    } else {
                      _communityFormKey.currentState.save();

                      _createCommunity();
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
        ),
      ),
    );
  }

  @override
  void initState() {
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _initCategoryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;
    final cuserId = Provider.of<UserData>(context, listen: false).userId;
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "Create",
                style: TextStyle(
                  fontFamily: "Lato",
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                unselectedLabelColor: Colors.grey[700],
                labelColor: Colors.black,
                labelStyle:
                TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Colors.black),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Text(
                    "CLUB",
                    style: TextStyle(
                      fontFamily: "Lato",
                      letterSpacing: 2.0
                    ),
                  ),
                  Text(
                    "COMMUNITY",
                    style: TextStyle(
                        fontFamily: "Lato",
                      letterSpacing: 2.0
                    ),
                  )
                ],
              ),
            ),
          body: TabBarView(
              controller: _tabController, children: [tabPage(0), tabPage(1)]),
        ),
      )
    );
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
