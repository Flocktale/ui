import 'dart:convert';
import 'dart:io';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final BuiltUser user;
  EditProfile({this.user});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _tagLineController = new TextEditingController();
  var _bioController = TextEditingController();
  bool usernameAvailable = false;
  File image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  updateProfile() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final newUser = BuiltUser(
      (b) => b
        ..userId = widget.user.userId
        ..tagline = _tagLineController?.text?.trim()
        ..bio = _bioController?.text?.trim(),
    );
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    final oldUserData = Provider.of<UserData>(context, listen: false).user;

    if (oldUserData.tagline != newUser.tagline ||
        oldUserData.bio != newUser.bio) {
      final resp = (await service.updateUser(
          userId: widget.user.userId, body: newUser, authorization: authToken));
      if (resp.isSuccessful) {
        Fluttertoast.showToast(msg: 'Your profile is updated!');

        if (image != null) {
          await _uploadImage();
        }
      }

      Navigator.of(context).pop(true);
    } else if (image != null) {
      await _uploadImage();
      Navigator.of(context).pop(true);
    } else
      Navigator.of(context).pop(false);
  }

  _uploadImage() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;

    var pickedImage = await image.readAsBytes();

    final imageInBase64 = base64Encode(pickedImage);

    final newImage = BuiltProfileImage((b) => b..image = imageInBase64);

    final resp = await service.uploadAvatar(
      userId: widget.user.userId,
      image: newImage,
      authorization: authToken,
    );
    if (resp.isSuccessful) {
      // clearing image cache so that
      PaintingBinding.instance.imageCache.clear();

      Fluttertoast.showToast(msg: "Profile Image Updated");
    } else {
      Fluttertoast.showToast(
          msg: "Some error occurred while uploading image!!!");
      print(resp.body);
    }
  }

  getImage() async {
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
          image = File(croppedImage.path);
        } else {
          print("Picture not selected.");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final _tempTagLineController =
        new TextEditingController(text: widget.user.tagline);
    final _tempBioController = TextEditingController(text: widget.user.bio);
    setState(() {
      _tagLineController = _tempTagLineController;
      _bioController = _tempBioController;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding: EdgeInsets.fromLTRB(
              //       size.width / 20, size.height / 20, 0, 0),
              //   child: RichText(
              //     text: TextSpan(
              //       text: "Edit",
              //       style: TextStyle(
              //           fontSize: size.width / 5,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black),
              //       children: [
              //         TextSpan(
              //           text: '.',
              //           style: TextStyle(color: Colors.red),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, size.height / 50, 0, 0),
                  child: GestureDetector(
                    onTap: getImage,
                    behavior: HitTestBehavior.deferToChild,
                    child: CircleAvatar(
                      radius: size.height / 14.7,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: size.height / 15,
                        backgroundImage: image == null
                            ? NetworkImage(widget.user.avatar)
                            : FileImage(image),
                        backgroundColor: Colors.white,
                        child: image == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: size.width / 15,
                                color: Colors.black,
                              )
                            : Align(
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
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: size.height / 50,
                    left: size.width / 20,
                    right: size.width / 20),
                child: Column(children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.user.name != null
                              ? widget.user.name
                              : widget.user.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width / 20,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: size.height / 50),
                        Text(
                          '@${widget.user.username}',
                          style: TextStyle(
                              fontSize: size.width / 26,
                              color: Colors.grey[400]),
                        ),
                        SizedBox(height: size.height / 50),
                        TextFormField(
                          //  initialValue: widget.user.tagline,
                          controller: _tagLineController,
                          maxLines: 1,
                          maxLength: 50,
                          decoration: InputDecoration(
                              labelText: 'TAGLINE ',
                              hintText: "Describe yourself in one line.",
                              hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey[400]),
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400]),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        // SizedBox(height: size.height/100),
                        TextFormField(
                          //   initialValue: widget.user?.bio,
                          controller: _bioController,
                          decoration: InputDecoration(
                              labelText: 'BIO',
                              hintText: "Tell something about yourself.",
                              hintStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w200,
                                  color: Colors.grey[400]),
                              labelStyle: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400]),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red))),
                        ),
                        SizedBox(height: 50),
                        InkWell(
                          onTap: () async {
                            await updateProfile();
                          },
                          child: Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.redAccent,
                                color: Colors.red,
                                elevation: 7.0,
                                child: Center(
                                  child: Text(
                                    'Submit Changes',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato'),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            ]));
  }
}
