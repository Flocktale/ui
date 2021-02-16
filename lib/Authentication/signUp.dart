import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mootclub_app/services/SecureStorage.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/pages/ProfileImagePage.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen();
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

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

    _changeLoading();

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;

    final _prefs = await SharedPreferences.getInstance();

    final _storage = SecureStorage();
    final email = await _storage.getEmail();

    final newUser = BuiltUser((b) => b
      ..userId = userId
      ..name = _nameController.text.trim()
      ..email = email
      ..username = _usernameController.text.trim());

    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final response = await service.createNewUser(
      body: newUser,
      authorization: authToken,
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
          authorization: authToken,
        );
        if (resp.isSuccessful) {
          Fluttertoast.showToast(msg: "Profile Image Uploaded");
        } else {
          Fluttertoast.showToast(
              msg: "Some error occurred while uploading image!!!");
          print(resp.body);
        }
      }

      final fcmToken = await FirebaseMessaging().getToken();

      // sending device token to backend to get notifications for this user on current device.
      Provider.of<DatabaseApiService>(context, listen: false).registerFCMToken(
        userId: userId,
        body: BuiltFCMToken((b) => b..deviceToken = fcmToken),
        authorization: authToken,
      );

      Provider.of<UserData>(context, listen: false).updateUser = newUser;

      // We don't need to push from here as Consumer at root path will automatically change the screen to home screen on listening changes of auth status;

    }

    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return _loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: "Signup",
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: getImage,
                      behavior: HitTestBehavior.deferToChild,
                      child: CircleAvatar(
                        radius: size.height / 11.7,
                        backgroundColor: Colors.red,
                        child: CircleAvatar(
                          radius: size.height / 12,
                          backgroundImage:
                              image == null ? null : FileImage(image),
                          backgroundColor: Colors.white,
                          child: image == null
                              ? Icon(
                                  Icons.add_a_photo,
                                  size: 32,
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
                                        size: 32,
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
                  padding: EdgeInsets.only(top: 12.0, left: 20.0, right: 20.0),
                  child: Column(children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                labelText: 'NAME',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400]),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: (val) {
                              if (val.isEmpty) return 'Please fill this field';
                              if (val.length < 3)
                                return 'Minimum length should be 3';

                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                labelText: 'USER NAME ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400]),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red))),
                            validator: (val) {
                              if (val.isEmpty) return 'Please fill this field';
                              if (val.length < 3)
                                return 'Minimum length should be 3';

                              return null;
                            },
                          ),
                          SizedBox(height: 50),
                          InkWell(
                            onTap: _signUpWithBackend,
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
                        ],
                      ),
                    ),
                  ]),
                )
              ]));
  }
}
