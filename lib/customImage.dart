import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final bool pinwheelPlaceholder;

  const CustomImage({Key key, this.image, this.pinwheelPlaceholder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: pinwheelPlaceholder
          ? 'assets/gifs/pinwheel.gif'
          : 'assets/gifs/fading_lines.gif',
      image: image,
    );
  }
}
