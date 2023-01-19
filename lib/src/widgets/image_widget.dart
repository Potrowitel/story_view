import 'dart:ui';

import 'package:flutter/material.dart';

import '../../stories.dart';

class ImageWidget2 extends StatelessWidget {
  final Story story;
  const ImageWidget2({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              story.url,
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Image.asset(
            story.url,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
