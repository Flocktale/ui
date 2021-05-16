import 'package:flocktale/Widgets/customImage.dart';
import 'package:flutter/material.dart';

class ImageDialogLayout extends StatelessWidget {
  final String imageUrl;
  final Widget content;
  const ImageDialogLayout({this.imageUrl, this.content});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // bottom part
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 20,
              top: 20 + 26.0,
              right: 20,
              bottom: 20,
            ),
            margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,
                ),
              ],
            ),
            child: content,
          ),
          //top part
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CustomImage(
                  image: imageUrl,
                  radius: 8,
                  pinwheelPlaceholder: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
