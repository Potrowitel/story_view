import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/models/story.dart';
import 'package:stories/src/models/story_process.dart';
import 'package:stories/src/models/story_ready.dart';

import 'package:stories/src/story_listen.dart';
import 'package:stories/src/widgets/animated_bar.dart';
import 'package:stories/src/widgets/story_item.dart';

class StoryScreen extends StatefulWidget {
  final int id;
  final List<Story> stories;
  final StoryController storyController;
  final StoriesController storiesController;
  final int initialPage;
  final int initialStory;
  final Function(int index)? onComplete;
  final Widget? timeoutWidget;
  final int? timeout;
  final bool exitButton;
  final bool isRepeat;
  final bool isOpen;
  final Function(int id)? onWatched;
  final Function(int index)? scrollToItem;
  final StoryAnimationController? storyAnimationController;
  bool allowDragg;
  final Function(bool isDragg)? onDragg;
  final StoriesWatchedController? watchedController;
  final bool isPopped;

  StoryScreen({
    Key? key,
    required this.id,
    required this.stories,
    required this.storyController,
    required this.storiesController,
    this.timeoutWidget,
    this.initialStory = 0,
    this.initialPage = 0,
    this.timeout,
    this.isRepeat = false,
    this.exitButton = true,
    this.onComplete,
    this.isOpen = false,
    this.onWatched,
    this.scrollToItem,
    this.storyAnimationController,
    required this.allowDragg,
    this.onDragg,
    this.watchedController,
    required this.isPopped,
  }) : super(key: key);

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late StoryListen _storyListen;
  Offset _offset = Offset.zero;
  Offset _fingerOffset = Offset.zero;
  double _opacity = 0;
  double radius = 0;
  late final double mediaWidth;
  late final double mediaHeigth;
  bool isDraging = false;
  late double scale;

  @override
  void initState() {
    super.initState();
    scale = 1;
    mediaHeigth =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
    mediaWidth =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    _storyListen = StoryListen(
        List.generate(
          widget.stories.length,
          (index) {
            return StoryReady(story: widget.stories[index]);
          },
        ),
        widget.initialStory);

    widget.storyController.status = StreamController<PlaybackState>();

    _storyListen.addListener(storyListener);
    widget.storyController.status?.stream.listen((event) {
      switch (event) {
        case PlaybackState.play:
          _play();
          break;
        case PlaybackState.pause:
          _pause();
          break;
        case PlaybackState.next:
          if (_storyListen.currentStatus == StoryStatus.complete) {
            _pause();
          }
          _nextPage();
          break;
        case PlaybackState.previous:
          if (_storyListen.currentStatus == StoryStatus.complete) {
            _pause();
          }
          _previousPage();
          break;
        case PlaybackState.reset:
          _reset();
          break;
        case PlaybackState.repeat:
          _repeat();
          break;
        case PlaybackState.wait:
          break;
        default:
          _reset();
          break;
      }
    });

    _pageController = PageController(initialPage: widget.initialStory);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.storyController.status?.add(PlaybackState.next);
      }
    });
  }

  void _play() {
    // print('PLAY ${_storyListen.currentStory}');
    if (_storyListen.currentStatus == StoryStatus.complete) {
      try {
        _animationController.forward();
        widget.storyController.play?.call();
        if (widget.allowDragg) {
          if (_storyListen.mediaType == MediaType.video) {
            widget.allowDragg = false;
          } else {
            widget.allowDragg = true;
          }
        }
      } catch (_) {
        _animationController.reset();
      }
    }
  }

  void _pause() {
    if (_storyListen.currentStatus == StoryStatus.complete) {
      try {
        _animationController.stop();
        if (_storyListen.mediaType == MediaType.video) {
          widget.storyController.pause?.call();
        }
      } catch (_) {
        _animationController.reset();
      }
    }
  }

  void _repeat() {
    try {
      _animationController.reset();
      _animationController.forward();
      if (_storyListen.mediaType == MediaType.video) {
        widget.storyController.repeat?.call();
      }
    } catch (_) {}
  }

  void _reset() {
    try {
      _animationController.reset();
      if (_storyListen.mediaType == MediaType.video) {
        widget.storyController.reset?.call();
      }
    } catch (_) {}
  }

  void _nextPage() {
    widget.onWatched?.call(_storyListen.currentStory);
    if (_storyListen.currentStory == widget.stories.length - 1) {
      if (widget.isRepeat) {
        _storyListen.changePage(id: 0);
        _pageController.jumpToPage(0);
      } else {
        if (isDraging) return;
        widget.watchedController?.setWatched(true, widget.id);
        widget.storyAnimationController?.index = _storyListen.currentStory;
        widget.storyAnimationController?.id = widget.id;
        widget.onComplete?.call(widget.id);
      }
    } else {
      _storyListen.pageIncrement();
      _pageController.jumpToPage(_storyListen.currentStory);
    }
  }

  void _previousPage() {
    if (_storyListen.currentStory == 0) {
      _storyListen.changePage(id: 0);
      _pageController.jumpToPage(0);
    } else {
      _storyListen.pageDecrement();
      _pageController.jumpToPage(_storyListen.currentStory);
    }
  }

  void storyListener() {
    if (widget.storiesController.id == widget.storyController.id &&
        _storyListen.currentStatus == StoryStatus.complete) {
      if (!widget.allowDragg) {
        widget.allowDragg = false;
      }
      _animationController.duration = _storyListen.getCurrentDuration();
      widget.storyController.status?.add(PlaybackState.repeat);
    }
    _animationController.duration = _storyListen.getCurrentDuration();
  }

  @override
  void dispose() {
    widget.storyController.status?.close();
    _storyListen.removeListener(storyListener);
    _storyListen.dis();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: widget.allowDragg
            ? const Color(0xFF062030).withOpacity(_opacity)
            : null,
        body: GestureDetector(
          onPanDown: (details) {
            _fingerOffset = details.globalPosition;
          },
          onPanCancel: () =>
              widget.storyController.status?.add(PlaybackState.play),
          onTapDown: (details) {
            _fingerOffset = details.globalPosition;
          },
          onTapUp: (details) =>
              widget.storyController.status?.add(PlaybackState.play),
          onLongPressStart: (_) =>
              widget.storyController.status?.add(PlaybackState.pause),
          onLongPressUp: () =>
              widget.storyController.status?.add(PlaybackState.play),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: mediaWidth,
            child: PageView.builder(
              itemCount: widget.stories.length,
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              pageSnapping: true,
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: widget.allowDragg ? _offset.dy : 0,
                      left: widget.allowDragg ? _offset.dx : 0,
                      child: Draggable(
                        maxSimultaneousDrags: 1,
                        hitTestBehavior: HitTestBehavior.translucent,
                        affinity: Axis.vertical,
                        feedback: const SizedBox.shrink(),
                        onDragUpdate: (details) {
                          if (widget.allowDragg) {
                            setState(() {
                              _offset = details.globalPosition - _fingerOffset;
                              double heightPercent = mediaHeigth / 100;
                              double offsetPercent = _offset.dy / heightPercent;
                              widget.storyController.status
                                  ?.add(PlaybackState.pause);
                              if (offsetPercent < 0) {
                                offsetPercent = 0;
                              }
                              _opacity = 0.9 - (1.8 * (offsetPercent / 100));
                              if (_opacity < 0) {
                                _opacity = 0;
                              }
                              if (offsetPercent > 30) {
                                offsetPercent = 30;
                              }
                              scale = 1 - offsetPercent / 100;
                              if (!widget.allowDragg) {
                                scale = 1;
                              }
                              isDraging = true;
                            });
                          }
                        },
                        onDragStarted: () {
                          radius = 40;
                          widget.onDragg?.call(true);
                          if (_storyListen.mediaType == MediaType.video) {
                            widget.allowDragg = false;
                          }
                        },
                        onDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dy > 100 ||
                              _offset.dy > mediaHeigth / 8) {
                            if (widget.allowDragg) {
                              widget.scrollToItem
                                  ?.call(_storyListen.currentStory);

                              widget.storyAnimationController?.dx = _offset.dx +
                                  (MediaQuery.of(context).size.width *
                                      (1 - scale) /
                                      2);
                              widget.storyAnimationController?.dy = _offset.dy +
                                  (MediaQuery.of(context).size.height *
                                      (1 - scale) /
                                      2);
                            }
                            widget.storyAnimationController?.opacity = _opacity;
                            widget.storyAnimationController?.index =
                                _storyListen.currentStory;
                            widget.storyAnimationController?.id = widget.id;
                            widget.storyAnimationController?.isOpen = false;
                            widget.storyAnimationController?.heigth =
                                MediaQuery.of(context).size.height * scale;
                            widget.storyAnimationController?.width =
                                MediaQuery.of(context).size.width * scale;
                            widget.watchedController
                                ?.setWatched(true, widget.id);
                            if (widget.isPopped) {
                              Navigator.of(context).pop();
                            }
                            return;
                          }
                          if (_offset.dy < mediaHeigth / 8 &&
                              widget.allowDragg) {
                            widget.onDragg?.call(false);
                            _offset = Offset.zero;
                            scale = 1;
                            radius = 0;
                            if (widget.allowDragg) {
                              widget.storyController.status
                                  ?.add(PlaybackState.play);
                            }
                            isDraging = false;
                            setState(() {});
                          }
                        },
                        child: SizedBox(
                          height: mediaHeigth,
                          width: mediaWidth,
                          child: Transform.scale(
                            scale: scale,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(radius),
                                      child: SizedBox(
                                        width: mediaWidth,
                                        height: mediaHeigth,
                                        child: StoryItem(
                                          id: index,
                                          globalId: widget.id,
                                          storyController:
                                              widget.storyController,
                                          story: widget.stories[index],
                                          timeout: widget.timeout,
                                          timeoutWidget: widget.timeoutWidget,
                                          onProcess: (process) {
                                            _storyListen.changeValue(
                                              id: process.id,
                                              status: process.status,
                                              duration: process.duration,
                                            );
                                          },
                                          // onLoading: (id) {
                                          //   _storyListen.changeValue(
                                          //       id: id, status: StoryStatus.loading);
                                          //   // print('LOADING');
                                          // },
                                          // onReady: (id, duration) async {
                                          //   _storyListen.changeValue(
                                          //       id: id,
                                          //       status: StoryStatus.ready,
                                          //       duration: duration);
                                          // if (id == (widget.initialStory) ||
                                          //     id == (widget.initialStory + 1) ||
                                          //     id == (widget.initialStory - 1)) {
                                          //   await Future.delayed(
                                          //       const Duration(milliseconds: 100));
                                          //   _storyListen.changeValue(
                                          //       id: id,
                                          //       status: StoryStatus.ready,
                                          //       duration: duration);
                                          // } else {
                                          //   _storyListen.changeValue(
                                          //       id: id,
                                          //       status: StoryStatus.ready,
                                          //       duration: duration);
                                          // }
                                          // print('READY');
                                          // },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 100),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => widget
                                                .storyController.status
                                                ?.add(PlaybackState.previous),
                                            child: SizedBox(
                                              width: mediaWidth / 3,
                                              height: double.infinity,
                                            ),
                                          ),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => widget
                                                .storyController.status
                                                ?.add(PlaybackState.next),
                                            child: SizedBox(
                                              width: mediaWidth / 3,
                                              height: double.infinity,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top:
                                      20.0 + MediaQuery.of(context).padding.top,
                                  left: 10.0,
                                  right: 10.0,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: widget.stories
                                            .asMap()
                                            .map((i, e) {
                                              return MapEntry(
                                                i,
                                                AnimatedBar(
                                                  animController:
                                                      _animationController,
                                                  position: i,
                                                  currentIndex: index,
                                                ),
                                              );
                                            })
                                            .values
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (widget.exitButton)
                                  Positioned(
                                    right: 5,
                                    top:
                                        50 + MediaQuery.of(context).padding.top,
                                    child: InkWell(
                                      onTap: () {
                                        if (widget.allowDragg) {
                                          widget.scrollToItem?.call(widget.id);
                                        }
                                        widget.storyAnimationController?.id =
                                            widget.id;
                                        widget.storyAnimationController?.dx = 0;
                                        widget.storyAnimationController?.dy = 0;
                                        widget.storyAnimationController
                                            ?.isOpen = true;
                                        widget.storyAnimationController?.index =
                                            _storyListen.currentStory;
                                        widget.storyAnimationController
                                                ?.heigth =
                                            MediaQuery.of(context).size.height;
                                        widget.storyAnimationController?.width =
                                            MediaQuery.of(context).size.width;

                                        widget.watchedController
                                            ?.setWatched(true, widget.id);
                                        if (widget.isPopped) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white24),
                                            child: const Material(
                                              color: Colors.transparent,
                                              child: Center(
                                                  child: Icon(
                                                      Icons.close_rounded,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                widget.stories[index].actionButton ??
                                    const SizedBox(),
                                widget.stories[index].child ?? const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
