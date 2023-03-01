import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/helper/behavior_helper.dart';
import 'package:stories/src/models/story.dart';
import 'package:stories/src/story_screen.dart';
import 'package:vector_math/vector_math.dart' as rad;

class StorySwipe extends StatefulWidget {
  final List<StoryCell> cells;
  final List<StoryController> storyControllers;
  final int initialPage;
  final int timeout;
  final Widget timeoutWidget;
  final bool exitButton;
  final PageController pageController;
  final StoriesController storiesController;
  final Function(int id, int storyId)? onWatched;
  final Function(int index) onPageComplete;
  final Color? statusBarColor;
  final StoryAnimationController storyAnimationController;
  final bool allowDragg;
  final StoriesWatchedController? watchedController;
  final bool isPopped;

  final Function(int index) scrollToItem;

  const StorySwipe({
    Key? key,
    required this.pageController,
    required this.storiesController,
    required this.cells,
    required this.storyControllers,
    required this.initialPage,
    required this.timeout,
    required this.timeoutWidget,
    required this.exitButton,
    required this.onPageComplete,
    this.statusBarColor,
    this.onWatched,
    required this.scrollToItem,
    required this.storyAnimationController,
    required this.allowDragg,
    this.watchedController,
    required this.isPopped,
  }) : super(key: key);

  @override
  _StorySwipeState createState() => _StorySwipeState();
}

class _StorySwipeState extends State<StorySwipe> {
  late PageController _pageController;
  List<StoryScreen> storyPages = [];
  bool _isDragg = false;
  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController;
    _pageController.addListener(listener);
    storyPages = List.generate(
      widget.cells.length,
      (i) => StoryScreen(
        id: i,
        storyController: widget.storyControllers[i],
        storiesController: widget.storiesController,
        watchedController: widget.watchedController,
        onWatched: (storyId) {
          if (widget.cells[i].stories.length - 2 == storyId &&
              widget.cells[i].stories.length > 1) {
            widget.watchedController?.setWatched(true, i);
            widget.onWatched?.call(i, storyId + 1);
          } else if (widget.cells[i].stories.length == 1) {
            widget.watchedController?.setWatched(true, i);
            widget.onWatched?.call(i, storyId);
          }
        },
        stories: widget.cells[i].stories,
        onComplete: widget.onPageComplete,
        initialPage: widget.initialPage,
        timeout: widget.timeout,
        timeoutWidget: widget.timeoutWidget,
        exitButton: widget.exitButton,
        scrollToItem: widget.scrollToItem,
        storyAnimationController: widget.storyAnimationController,
        allowDragg: widget.allowDragg,
        isPopped: widget.isPopped,
        onDragg: (isDragg) {
          setState(() {
            _isDragg = isDragg;
          });
        },
      ),
    );
  }

  void listener() {
    setState(() {
      // currentPageValue = _pageController.page!;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _pageController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Material(
        color: _isDragg ? Colors.transparent : Colors.black,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: PageView.builder(
            controller: _pageController,
            itemCount: storyPages.length,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            allowImplicitScrolling: true,
            itemBuilder: (context, index) {
              double value;
              widget.storyControllers[index].setStory(index);
              if (_pageController.position.haveDimensions == false) {
                value = index.toDouble();
              } else {
                value = _pageController.page!;
              }

              return _SwipeWidget(
                index: index,
                pageNotifier: value,
                child: storyPages[index],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SwipeWidget extends StatelessWidget {
  final int index;
  final double pageNotifier;
  final Widget child;

  const _SwipeWidget({
    Key? key,
    required this.index,
    required this.pageNotifier,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLeaving = (index - pageNotifier) <= 0;
    final t = (index - pageNotifier);
    final rotationY = lerpDouble(0, 90, t);
    final transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    transform.rotateY(-rad.radians(rotationY!));
    return Transform(
      alignment: isLeaving ? Alignment.centerRight : Alignment.centerLeft,
      transform: transform,
      child: child,
    );
  }
}
