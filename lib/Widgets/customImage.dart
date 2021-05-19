import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final bool pinwheelPlaceholder;
  final double radius;
  final BoxFit fit;

  const CustomImage(
      {Key key,
      this.image,
      this.pinwheelPlaceholder = false,
      this.radius = 100,
      this.fit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: FadeInImage.assetNetwork(
        fit: BoxFit.fill,
        placeholder: pinwheelPlaceholder
            ? 'assets/gifs/pinwheel.gif'
            : 'assets/gifs/fading_lines.gif',
        image: image,
        imageErrorBuilder: (ctx, _, __) {
          return Image.asset(
            'assets/images/logo.png',
            fit: fit,
          );
        },
      ),
    );
  }
}
