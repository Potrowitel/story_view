import 'dart:async';

import 'package:flutter/material.dart';

enum LoadState { loading, success, failure, downloading }

enum PlaybackState {
  init,
  pause,
  play,
  next,
  previous,
  onComplete,
  loading,
  reset,
  wait,
  repeat
}

class StoriesController extends ScrollController {
  int? _currentPage;
  bool? init;
  int? get id => _currentPage;
  VoidCallback? play;
  VoidCallback? pause;
  VoidCallback? next;
  VoidCallback? previous;
  VoidCallback? close;
  VoidCallback? reset;

  void setPage(int value) => _currentPage = value;
}

class StoryController {
  int _id;
  get id => _id;

  StreamController<PlaybackState>? status;
  VoidCallback? pause;
  VoidCallback? play;
  VoidCallback? repeat;
  VoidCallback? next;
  VoidCallback? previous;
  VoidCallback? reset;
  StoryController(this._id);

  void setStory(int value) => _id = value;
}

class StoryAnimationController {
  int id;
  int index;
  double heigth;
  double width;
  double dy;
  double dx;
  bool isOpen;
  double? opacity;

  StoryAnimationController({
    required this.id,
    required this.index,
    required this.heigth,
    required this.width,
    required this.dy,
    required this.dx,
    required this.isOpen,
    this.opacity,
  });
}

class StoriesWatchedController extends ChangeNotifier {
  List<bool> _isWatched;
  StoriesWatchedController(this._isWatched);
  bool watched(int id) {
    return _isWatched[id];
  }

  bool setWatched(bool val, int id) {
    _isWatched[id] = val;
    notifyListeners();
    return _isWatched[id];
  }
}
