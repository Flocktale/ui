import 'dart:convert';
import 'dart:io';

import 'package:flocktale/Authentication/logOut.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _tagLineController = TextEditingController();
  final _bioController = TextEditingController();
  bool usernameAvailable = false;
  File image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  _changeLoading() {
    if (!this.mounted) return;

    setState(() {
      _loading = !_loading;
    });
  }

  _checkBackendForUsernameAvailability(String val) async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);

    UsernameAvailability resp = (await service.isThisUsernameAvailable(
      username: val,
    ))
        .body;
    if (resp?.isAvailable == true && _usernameController.text.length >= 3) {
      setState(() {
        usernameAvailable = true;
      });
    } else {
      setState(() {
        usernameAvailable = false;
      });
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

  _signUpWithBackend() async {
    if (_nameController.text.isEmpty || _usernameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter all the fields');
      return;
    }
    if (_usernameController.text.length < 3 ||
        _usernameController.text.length > 25) {
      Fluttertoast.showToast(msg: 'USER NAME length must be between 3 to 25');
      return;
    }
    if (_nameController.text.length < 3 || _nameController.text.length > 25) {
      Fluttertoast.showToast(msg: 'NAME length must be between 3 to 25');
      return;
    }
    if (usernameAvailable == false) {
      Fluttertoast.showToast(msg: 'Please change your username');
      return;
    }

    _changeLoading();

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final phoneNumber =
        Provider.of<UserData>(context, listen: false).phoneNumber;

    final newUser = BuiltUser(
      (b) => b
        ..userId = userId
        ..name = _nameController.text.trim()
        ..phone = phoneNumber
        ..username = _usernameController.text.trim()
        ..tagline = _tagLineController?.text?.trim()
        ..bio = _bioController?.text?.trim(),
    );

    final response = await service.createNewUser(
      body: newUser,
    );

    if (response.isSuccessful) {
      Fluttertoast.showToast(msg: 'Your registration is successfull!');

      if (image != null) {
        var pickedImage = await image.readAsBytes();

        final imageInBase64 = base64Encode(pickedImage);

        final newImage = BuiltProfileImage((b) => b..image = imageInBase64);

        final resp = await service.uploadAvatar(
          userId: userId,
          image: newImage,
        );
        if (resp.isSuccessful) {
          Fluttertoast.showToast(msg: "Profile Image Uploaded");
        } else {
          Fluttertoast.showToast(
              msg: "Some error occurred while uploading image!!!");
          print(resp.body);
        }
      }

      Provider.of<UserData>(context, listen: false).initiate(isNew: true);

      // We don't need to push from here as Consumer at root path will automatically change the screen to home screen on listening changes of auth status;

    }

    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _loading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
                body: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.width / 20, size.height / 20, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Register",
                        style: TextStyle(
                            fontSize: size.width / 5,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                        children: [
                          TextSpan(
                            text: '.',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
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
                            backgroundImage:
                                image == null ? null : FileImage(image),
                            backgroundColor: Colors.white,
                            child: image == null
                                ? Icon(
                                    Icons.add_a_photo,
                                    size: size.width / 15,
                                    color: Colors.redAccent,
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
                                          color: Colors.redAccent,
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
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  labelText: 'NAME',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400]),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                if (val.length < 3)
                                  return 'Minimum length should be 3';

                                return null;
                              },
                            ),
                            SizedBox(height: size.height / 50),
                            TextFormField(
                              controller: _usernameController,
                              style: TextStyle(color: Colors.white),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9_]')),
                              ],
                              decoration: InputDecoration(
                                  labelText: 'USER NAME ',
                                  labelStyle: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400]),
                                  helperText: _usernameController.text.length >=
                                          3
                                      ? usernameAvailable
                                          ? "Username is available"
                                          : "Username is not available"
                                      : "Allowed Characters: a-z 0-9 _ (Min length: 3)",
                                  helperStyle: !usernameAvailable ||
                                          _usernameController.text.length < 3
                                      ? TextStyle(
                                          fontFamily: "Lato", color: Colors.red)
                                      : TextStyle(
                                          fontFamily: "Lato",
                                          color: Colors.green),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: _usernameController
                                                  .text.length >
                                              3
                                          ? usernameAvailable
                                              ? BorderSide(color: Colors.green)
                                              : BorderSide(
                                                  color: Colors.redAccent)
                                          : BorderSide(
                                              color: Colors.redAccent))),
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.done,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              maxLength: 25,
                              onChanged: (val) async {
                                if (val.isEmpty || val.length < 3) return;
                                val = val.toLowerCase();

                                await _checkBackendForUsernameAvailability(val);
                              },
                              validator: (val) {
                                if (val.isEmpty)
                                  return 'Please fill this field';
                                if (val.length < 3)
                                  return 'Minimum length should be 3';

                                return null;
                              },
                            ),
                            SizedBox(height: size.height / 50),
                            TextFormField(
                              controller: _tagLineController,
                              minLines: 1,
                              maxLines: 3,
                              maxLength: 100,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  labelText: 'TAGLINE',
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
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                            ),
                            // SizedBox(height: size.height/100),
                            TextFormField(
                              controller: _bioController,
                              minLines: 3,
                              maxLines: 15,
                              style: TextStyle(color: Colors.white),
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
                                      borderSide:
                                          BorderSide(color: Colors.red))),
                            ),
                            SizedBox(height: 50),
                            InkWell(
                              onTap: () => _signUpWithBackend(),
                              child: Container(
                                  height: 40.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.redAccent,
                                    color: Colors.red,
                                    elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        'SUBMIT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato'),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: size.height / 50,
                            ),
                            InkWell(
                              onTap: () async {
                                //TODO
                                //Progress Indicator here
                                await logOutUser(context);
                              },
                              child: Container(
                                  height: size.height / 20,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.redAccent,
                                    color: Colors.white,
                                    elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        'Log out',
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lato'),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ]),
                  )
                ])),
          );
  }
}
