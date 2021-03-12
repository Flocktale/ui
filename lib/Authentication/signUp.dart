import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flocktale/services/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocktale/Models/built_post.dart';
import 'package:flocktale/providers/userData.dart';
import 'package:flocktale/services/chopper/database_api_service.dart';
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
  _logOutUser() async {
    final _storage = SecureStorage();
    await _storage.logout();
    final _user = Provider.of<UserData>(context,listen:false).user;
    Provider.of<DatabaseApiService>(context, listen: false).deleteFCMToken(
      userId: _user.userId,
      authorization: null,
    );
    Phoenix.rebirth(context);
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
    if(usernameAvailable==false){
      Fluttertoast.showToast(msg: 'Please change your username');
      return;
    }

    _changeLoading();

    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final userId = Provider.of<UserData>(context, listen: false).userId;
    final phoneNumber =
        Provider.of<UserData>(context, listen: false).phoneNumber;

    final _prefs = await SharedPreferences.getInstance();

    final newUser = BuiltUser(
      (b) => b
        ..userId = userId
        ..name = _nameController.text.trim()
        ..phone = phoneNumber
        ..username = _usernameController.text.trim()
        ..tagline = _tagLineController?.text?.trim()
        ..bio = _bioController?.text?.trim(),
    );

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
                  padding: EdgeInsets.fromLTRB(
                      size.width / 20, size.height / 20, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      text: "Register",
                      style: TextStyle(
                          fontSize: size.width / 5,
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
                          SizedBox(height: size.height / 50),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                                labelText: 'USER NAME ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[400]),
                                helperText: _usernameController.text.length>3?
                                usernameAvailable?

                                      "Username is available"
                                    : "Username is not available"
                                    : "Minimum length of username is 4",

                                helperStyle:
                                !usernameAvailable || _usernameController.text.length<=3?
                                TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.red
                                ):
                                TextStyle(
                                  fontFamily: "Lato",
                                  color: Colors.green
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: _usernameController.text.length>3?
                                    usernameAvailable?
                                    BorderSide(color: Colors.green):
                                        BorderSide(color: Colors.redAccent):
                                        BorderSide(color:Colors.redAccent)
                                )),
                            onChanged: (val)async{
                              final service = Provider.of<DatabaseApiService>(context,listen:false);
                              final authToken = Provider.of<UserData>(context,listen:false).authToken;
                              UsernameAvailability resp = (await service.isThisUsernameAvailable(username: val, authorization: authToken)).body;
                              if(resp.isAvailable && _usernameController.text.length>3){
                                setState(() {
                                  usernameAvailable = true;
                                });
                              }
                              else{
                                setState(() {
                                  usernameAvailable = false;
                                });
                              }
                            },
                            validator: (val) {
                              if (val.isEmpty) return 'Please fill this field';
                              if (val.length < 3)
                                return 'Minimum length should be 3';

                              return null;
                            },
                          ),
                          SizedBox(height: size.height / 50),
                          TextFormField(
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
                          SizedBox(
                            height: size.height/50,
                          ),
                          InkWell(
                            onTap: ()async{
                              //TODO
                              //Progress Indicator here
                              await _logOutUser();
                            },
                            child: Container(
                                height: size.height/20,
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
                        ],
                      ),
                    ),
                  ]),
                )
              ]));
  }
}
