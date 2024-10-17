import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stories/src/models/story_back.dart';

class StoryBackground extends StatelessWidget {
  final String? type;
  final Color? gradientStart;
  final Color? gradientEnd;
  final String? url;
  final BaseCacheManager? cacheManager;

  const StoryBackground({
    Key? key,
    this.type,
    this.gradientEnd,
    this.gradientStart,
    this.url,
    this.cacheManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: type == StoryBack.gradient &&
              gradientStart != null &&
              gradientEnd != null
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradientStart!,
                  gradientEnd!,
                ],
              ),
            )
          : null,
      child: type == StoryBack.image
          ? CachedNetworkImage(
              cacheManager: cacheManager,
              imageUrl: url ?? '',
              fit: BoxFit.cover,
            )
          : null,
    );
  }
}
