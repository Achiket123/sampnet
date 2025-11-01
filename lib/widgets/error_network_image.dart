import 'package:flutter/material.dart';

class ErrorNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String defaultImage;
  const ErrorNetworkImage(
      {super.key, required this.imageUrl, required this.defaultImage});
  @override
  Widget build(BuildContext context) {
    try {
      return Image.network(
        imageUrl,
        errorBuilder: (context, error, stackTrace) => Image.asset(defaultImage),
      );
    } catch (e) {
      return Image.asset(defaultImage);
    }
  }
}
