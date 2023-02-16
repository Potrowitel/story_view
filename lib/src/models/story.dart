import 'package:flutter/material.dart';

enum MediaType {
  image,
  video,
}

class StoryCell {
  final String iconUrl;
  final List<Story> stories;
  final bool watched;

  StoryCell({
    required this.iconUrl,
    required this.stories,
    required this.watched,
  });

  // StoryCell copyWith({String? iconUrl, List<Story>? stories, bool? watched}) {
  //   return StoryCell(
  //     iconUrl: iconUrl ?? this.iconUrl,
  //     stories: stories ?? this.stories,
  //     watched: watched ?? this.watched,
  //   );
  // }
}

class Story {
  final String url;
  final MediaType meadiaType;
  final String? backType;
  final String? backUrl;
  final Color? gradientStart;
  final Color? gradientEnd;
  final Duration? duration;
  final Widget? actionButton;
  final Widget? child;

  Story({
    required this.url,
    this.child,
    this.meadiaType = MediaType.image,
    this.duration = const Duration(seconds: 5),
    this.actionButton,
    this.gradientEnd,
    this.gradientStart,
    this.backType,
    this.backUrl,
  });
}
