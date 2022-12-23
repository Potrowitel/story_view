import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/story_screen.dart';
import 'package:stories/src/widgets/story_animation.dart';
import 'package:stories/src/widgets/swipe.dart';
import 'package:stories/stories.dart';

typedef ActionButtonClicked = void Function();

class Stories extends StatefulWidget {
  final List<StoryCell> cells;
  final int timeout;
  final Widget? timeoutWidget;
  final double? cellHeight;
  final double? cellWidht;
  final bool exitButton;
  final Color? statusBarColor;
  final Function(int id, int sroryId)? onWatched;

  const Stories({
    Key? key,
    required this.cells,
    this.timeout = 20,
    this.timeoutWidget,
    this.cellHeight,
    this.cellWidht,
    this.statusBarColor,
    this.onWatched,
    this.exitButton = true,
  }) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List<StoryScreen> storyPages = [];
  late List<StoryController> _storyControllers;
  late StoriesController _storiesController;
  late PageController _pageController;

  late int _currentPage;
  List<GlobalKey> keys = [];

  void onPageComplete() {
    if (_pageController.page == widget.cells.length - 1) {
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }

    for (var controller in _storyControllers) {
      if (controller.status != null && !controller.status!.isClosed) {
        controller.status?.add(PlaybackState.reset);
      }
    }
    _pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _storiesController = StoriesController();

    _storyControllers =
        List.generate(widget.cells.length, (index) => StoryController(index));

    _pageController = PageController();

    for (int i = 0; i < widget.cells.length; i++) {
      keys.add(GlobalKey());
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(pageListener);
    _pageController.dispose();
    _storiesController.dispose();
    super.dispose();
  }

  void pageListener() {
    if (_pageController.page! % 1 == 0) {
      _currentPage = _pageController.page!.toInt();
      _storiesController.setPage(_currentPage);
      if (_currentPage != 0) {
        _storyControllers[_currentPage - 1].status?.add(PlaybackState.reset);
      }
      // print('PLAY ${_currentPage}');
      _storyControllers[_currentPage].status?.add(PlaybackState.play);
      // _storyControllers[_currentPage].update?.call();
      if (_currentPage != _storyControllers.length - 1) {
        _storyControllers[_currentPage + 1].status?.add(PlaybackState.reset);
      }
    } else {
      for (var controller in _storyControllers) {
        if (controller.status != null && !controller.status!.isClosed) {
          controller.status?.add(PlaybackState.pause);
        }
      }
    }
  }

  void _onStorySwipeClicked(int initialPage) {
    _currentPage = initialPage;
    _pageController = PageController(initialPage: _currentPage);

    _pageController.addListener(pageListener);
    _storiesController.setPage(_currentPage);
    _storiesController.init = true;
    Navigator.push(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => StorySwipe(
                statusBarColor: widget.statusBarColor,
                cells: widget.cells,
                exitButton: widget.exitButton,
                initialPage: initialPage,
                onPageComplete: onPageComplete,
                onWatched: widget.onWatched,
                storyControllers: _storyControllers,
                timeout: widget.timeout,
                pageController: _pageController,
                storiesController: _storiesController,
                timeoutWidget: widget.timeoutWidget ?? const SizedBox(),
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animation.isCompleted) {
              return child;
            }
            return StoryAnimation(
              storyCell: widget.cells[initialPage],
              cells: widget.cells,
              index: initialPage,
              cellHeight: widget.cellHeight,
              cellWidht: widget.cellWidht,
              cellKey: keys[initialPage],
              animation: animation,
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.cellHeight ?? 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.cells.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _onStorySwipeClicked(index);
            },
            child: Padding(
              key: keys[index],
              padding: const EdgeInsets.all(5.0).copyWith(
                  left: index == 0 ? 16 : 5,
                  right: index == widget.cells.length - 1 ? 16 : 5),
              child: Container(
                width: widget.cellWidht != null ? widget.cellWidht! + 10.0 : 80,
                height:
                    widget.cellHeight != null ? widget.cellHeight! + 10.0 : 80,
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF4C43C),
                      Color(0xFF2AB67C),
                    ],
                  ),
                ),
                child: Container(
                  width: widget.cellWidht != null ? widget.cellWidht! + 9 : 79,
                  height:
                      widget.cellHeight != null ? widget.cellHeight! + 9 : 79,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.cells[index].iconUrl,
                      errorWidget: (context, url, error) {
                        return Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.black);
                      },
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: widget.cellWidht ?? 70,
                          height: widget.cellHeight ?? 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
