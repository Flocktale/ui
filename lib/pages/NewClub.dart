import 'dart:convert';
import 'dart:io';

import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flocktale/providers/agoraController.dart';
import 'ClubDetailPages/ClubDetail.dart';
import 'package:image_cropper/image_cropper.dart';

class NewClub extends StatefulWidget {
  final BuiltCommunity community;
  NewClub({this.community});
  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _category;

  bool _isScheduledClub = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _scheduleTimeController = TextEditingController(
      text: DateTime.now().add(Duration(minutes: 5)).toString());

  List<String> _categoryList = [];
  File _image;

  final _picker = ImagePicker();

  _getImage() async {
    final selectedImage = await _picker.getImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: selectedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
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
          _image = File(croppedImage.path);
        } else {
          print("Picture not selected.");
        }
      });
    }
  }

  BuiltClub get _newClubModel {
    if (_category?.isNotEmpty != true) {
      Fluttertoast.showToast(msg: 'Please select category');
      return null;
    }
    int scheduleDateTime;

    if (_isScheduledClub) {
      var parsedDate = DateTime.parse(
          _scheduleTimeController.text ?? DateTime.now().toIso8601String());

      scheduleDateTime = parsedDate.millisecondsSinceEpoch;
    } else {
      scheduleDateTime = DateTime.now().millisecondsSinceEpoch;
    }

    return BuiltClub(
      (b) => b
        ..clubName = _nameController.text
        ..description = _descriptionController.text
        ..category = _category
        ..scheduleTime = scheduleDateTime,
    );
  }

  _createClub() async {
    if (_newClubModel == null) return;
    setState(() {
      _isLoading = true;
    });

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;

    final resp = widget.community != null
        ? await service.createNewCommunityClub(
            creatorId: userId,
            communityId: widget.community.communityId,
            body: _newClubModel)
        : await service.createNewGeneralClub(
            body: _newClubModel,
            creatorId: userId,
          );

    if (resp.isSuccessful) {
      final clubId = resp.body['clubId'];
      if (_image != null) {
        var pickedImage = await _image.readAsBytes();
        final newImage =
            BuiltProfileImage((b) => b..image = base64Encode(pickedImage));
        await service.updateClubAvatar(
          clubId: clubId,
          image: newImage,
        );
      }
      Fluttertoast.showToast(msg: 'club entry is created');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClubDetailPage(clubId),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'error in creating club');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    String label,
    Function(String) validator,
    TextEditingController controller,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(12)),
        focusColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _dropDownWidget({
    String hint,
    Function(String) onChanged,
    String value,
    List<String> itemList,
  }) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButton(
          hint: Center(
            child: Text(
              hint ?? 'Select Category',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          dropdownColor: Colors.black87,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
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
                  alignment: Alignment.center,
                  child: Card(
                    shadowColor: Colors.white,
                    color: Colors.black,
                    elevation: 2,
                    child: Text(
                      valueItem,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
            );
          }).toList(),
        ),
      );

  Widget _buildCategory() {
    return _dropDownWidget(
      onChanged: (newValue) {
        _category = newValue;
        setState(() {});
      },
      value: _category,
      itemList: _categoryList ?? [],
    );
  }

  Widget _dateTimePicker() {
    return DateTimePicker(
      controller: _scheduleTimeController,
      type: DateTimePickerType.dateTimeSeparate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      icon: Icon(
        Icons.event,
        color: Colors.white,
      ),
      style: TextStyle(color: Colors.white),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      use24HourFormat: true,
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
            color: Colors.white,
          ),
        ),
        Switch(
          activeColor: Colors.red,
          inactiveTrackColor: Colors.white24,
          value: _isScheduledClub,
          onChanged: (val) {
            if (val) {
              _isScheduledClub = true;
            } else {
              _isScheduledClub = false;
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
    _categoryList = userData.categoryData['categories'];

    setState(() {});
  }

  _showMaterialDialog() async {
    BuiltClub activeClub =
        Provider.of<AgoraController>(context, listen: false).club;

    final actionButton = ({String title, bool result = false}) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pop(result);
        },
        child: Card(
          elevation: 4,
          shadowColor: Colors.redAccent,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    };
    final res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Please end the club \"${activeClub?.clubName ?? ' '}\" before entering another club.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        actionButton(title: 'Cancel', result: false),
                        SizedBox(width: 12),
                        actionButton(title: 'Go to Club', result: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    if (res == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClubDetailPage(activeClub.clubId),
        ),
      );
    }
  }

  Widget _inputImageWidget() {
    return GestureDetector(
      onTap: _getImage,
      behavior: HitTestBehavior.deferToChild,
      child: Card(
        shadowColor: Colors.redAccent,
        color: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          height: 144,
          width: 144,
          child: LayoutBuilder(builder: (context, constraints) {
            if (_image == null) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 24,
                      color: Colors.white,
                      semanticLabel: "Add a photo",
                    ),
                    Text(
                      "Add a club avatar",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            }
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(image: FileImage(_image))),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      _image = null;
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black87,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _displayCommunity() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Container(
                height: 64,
                width: 64,
                child: CustomImage(
                  image: widget.community.avatar,
                  radius: 12,
                ),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.community.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void initState() {
    _initCategoryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuiltClub club = Provider.of<AgoraController>(context, listen: false).club;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Create Club",
            style: TextStyle(
              fontFamily: "Lato",
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  children: <Widget>[
                    Center(child: _inputImageWidget()),
                    SizedBox(height: 12),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          if (widget.community != null) _displayCommunity(),
                          _buildTextField(
                              label: "Name",
                              controller: _nameController,
                              validator: (value) {
                                if (value.isEmpty) return 'Required';
                                if (value.length < 3)
                                  return 'Minimum 3 characters';
                                if (value.length > 40)
                                  return 'Maximum 40 characters';

                                return null;
                              }),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: "Description",
                            controller: _descriptionController,
                            maxLines: 5,
                          ),
                          SizedBox(height: 16),
                          _buildCategory(),
                          SizedBox(height: 16),
                          _scheduleClub(),
                          _isScheduledClub ? _dateTimePicker() : Container(),
                          SizedBox(height: 32),
                          RaisedButton(
                            onPressed: () {
                              if (club != null) {
                                _showMaterialDialog();
                              } else if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                _createClub();
                              }
                            },
                            color: Colors.red[600],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              child: Text('Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                  )),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
