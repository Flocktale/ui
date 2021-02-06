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

class ImagePage extends StatefulWidget {
  final String name;
  final String description;
  final String category;
  final String userId;
  ImagePage({this.name, this.description, this.category, this.userId});
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File image;
  final picker = ImagePicker();
  getImage(ImageSource source) async {
    final selectedImage = await picker.getImage(source: source);
    if (selectedImage != null) {
      final croppedImage = await ImageCropper.cropImage(
          sourcePath: selectedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 50,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              statusBarColor: Colors.amber,
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

  _createClub() async {
    if (widget.name == null ||
        widget.name.isEmpty ||
        widget.description == null ||
        widget.description.isEmpty ||
        widget.category == null ||
        widget.category.isEmpty) {
      Fluttertoast.showToast(msg: 'Fill all fields');
      print('flll all the fields');
      return;
    }

    print('sending');

    final service = Provider.of<DatabaseApiService>(context, listen: false);

    final newClub = BuiltClub((b) => b
      ..clubName = widget.name
      ..description = widget.description
      ..category = widget.category);

    final authToken = Provider.of<UserData>(context, listen: false).authToken;
    final resp = await service.createNewClub(newClub, widget.userId,
        authorization: authToken);
    
    if(resp.isSuccessful && image!=null){
      String imageInBase64;
      if(image!=null){
        var pickedImage = await image.readAsBytes();
        imageInBase64 = base64Encode(pickedImage);
      }
    }
    print('=========' + resp.body);
    print(resp.error);
    Fluttertoast.showToast(msg: 'club entry is created');
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
          Container(
            height: size.height / 2,
            width: size.width / 2,
            child: Center(
              child: image == null
                  ? Text('No image selected.')
                  : Image.file(image),
            ),
          ),
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
              : ButtonTheme(
                  child: RaisedButton(
                    onPressed: () {
                      print(widget.name);
                      print(widget.description);
                      print(widget.category);
                      print(widget.userId);
                      _createClub();
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
                )
        ],
      ),
    );
  }
}
