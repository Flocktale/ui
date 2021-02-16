import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mootclub_app/Models/built_post.dart';
import 'package:mootclub_app/providers/userData.dart';
import 'package:mootclub_app/services/chopper/database_api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mootclub_app/services/SecureStorage.dart';

import 'ProfilePage.dart';

class ProfileImagePage extends StatefulWidget {
  final String name;
  final String userName;
  ProfileImagePage({this.name, this.userName});
  @override
  _ProfileImagePageState createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  File image;
  final picker = ImagePicker();
  getImage(ImageSource source) async {
    final selectedImage = await picker.getImage(source: source);
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

  uploadImage() async {
    final service = Provider.of<DatabaseApiService>(context, listen: false);
    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final userId = Provider.of<UserData>(context, listen: false).userId;

    String imageInBase64;
    var pickedImage = await image.readAsBytes();
    imageInBase64 = base64Encode(pickedImage);
    final newImage = BuiltProfileImage((b) => b..image = imageInBase64);

    final resp = await service.uploadAvatar(
      userId: userId,
      image: newImage,
      authorization: authToken,
    );
    if (resp.isSuccessful) {
      Fluttertoast.showToast(msg: "Profile Image Uploaded");
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: "Some error occurred. Please try again.");
      print(resp.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick an Image',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image == null
              ? Container(
                  height: size.height / 2,
                  width: size.width / 2,
                  child: Center(child: Text('No image selected.')),
                )
              : Center(
                  child: Container(
                  margin: EdgeInsets.fromLTRB(0, size.height / 14, 0, 0),
                  child: CircleAvatar(
                    radius: size.height / 18,
                    backgroundImage: FileImage(image),
                  ),
                )),
          image == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ButtonTheme(
                      child: RaisedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Text(
                          "Open Camera",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Lato',
                              color: Colors.black),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    ButtonTheme(
                      child: RaisedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Text(
                          "Open Gallery",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Lato',
                              color: Colors.black),
                        ),
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              : Container(
                  margin: EdgeInsets.fromLTRB(0, size.height / 2, 0, 0),
                  child: ButtonTheme(
                    child: RaisedButton(
                      onPressed: () {
                        print(widget.name);
                        print(widget.userName);
                        uploadImage();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.red,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
