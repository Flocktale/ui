import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final bool pinwheelPlaceholder;
  final double radius;

  const CustomImage(
      {Key key,
      this.image,
      this.pinwheelPlaceholder = false,
      this.radius = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: FadeInImage.assetNetwork(
        placeholder: pinwheelPlaceholder
            ? 'assets/gifs/pinwheel.gif'
            : 'assets/gifs/fading_lines.gif',
        image: image,
      ),
    );
  }
}
