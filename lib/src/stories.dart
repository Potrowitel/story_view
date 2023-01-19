import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/models/stoty_size.dart';
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
  final bool allowBorder;
  final bool allowAnimation;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Duration imageSwitchDuration;
  final Duration reverseImageSwitchDuration;
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
    this.allowBorder = true,
    this.allowAnimation = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.imageSwitchDuration = const Duration(milliseconds: 200),
    this.reverseImageSwitchDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List<StoryScreen> storyPages = [];
  late List<StoryController> _storyControllers;
  late StoriesController _storiesController;
  late PageController _pageController;

  final ScrollController _scrollController = ScrollController();
  late final ListObserverController _observerController;
  final GlobalKey _key = GlobalKey();
  late int _currentPage;
  late double x;
  int currentItemIndex = 0;
  late double countItemOnScreen;
  late StorySizeModel sizeModel;

  void onPageComplete(int index) {
    if (_pageController.page == widget.cells.length - 1) {
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        scrollToItem(index);
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

  void scrollToItem(int index) {
    double itemWidth =
        (MediaQuery.of(context).size.width - widget.cellWidht! + 7) * 0.00001 +
            widget.cellWidht! -
            6;
    countItemOnScreen = MediaQuery.of(context).size.width / (itemWidth + 10);
    double offset = (itemWidth + 10) * _storiesController.id!;
    if (currentItemIndex <= _storiesController.id! &&
        _storiesController.id! < countItemOnScreen + currentItemIndex) {
      x = (widget.cellWidht! +
          42 -
          _scrollController.offset -
          13 +
          (_storiesController.id! - 1) * 75 * 0.9999);
    } else if (_storiesController.id! >= widget.cells.length - 2) {
      _scrollController.animateTo(offset - 2 * itemWidth,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      x = (widget.cellWidht! +
          42 -
          (offset - 2 * itemWidth) -
          13 +
          (_storiesController.id! - 1) * 75 * 0.9999);
    } else {
      _scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

      x = (widget.cellWidht! +
          42 -
          offset -
          13 +
          (_storiesController.id! - 1) * 75 * 0.9999);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _storiesController = StoriesController();

    _observerController = ListObserverController(controller: _scrollController);

    _scrollController.addListener(() {
      offsetListener();
    });

    _storyControllers =
        List.generate(widget.cells.length, (index) => StoryController(index));

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.removeListener(pageListener);
    _scrollController.removeListener(offsetListener);
    _pageController.dispose();
    _storiesController.dispose();
    super.dispose();
  }

  void offsetListener() {
    currentItemIndex = ((_scrollController.offset + 10) / 75).floor();
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

    RenderBox box = _key.currentContext?.findRenderObject() as RenderBox;

    var position = box.localToGlobal(Offset.zero);
    var y = position.dy;
    x = (widget.cellWidht! +
        42 -
        _scrollController.offset -
        13 +
        (_storiesController.id! - 1) * 75 * 0.9999);
    sizeModel = StorySizeModel(
      id: 0,
      heigth: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      dy: widget.cells[initialPage].stories.first.meadiaType == MediaType.video
          ? 0.0
          : MediaQuery.of(context).viewPadding.top -
              MediaQuery.of(context).viewPadding.bottom +
              30,
      dx: 0,
      isOpen: true,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          transitionDuration: widget.transitionDuration,
          reverseTransitionDuration: widget.reverseTransitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return StorySwipe(
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
              scrollToItem: scrollToItem,
              sizeModel: sizeModel,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animation.isCompleted) {
              return child;
            }
            double statusBarHeigth = MediaQuery.of(context).viewPadding.top;
            return widget.allowAnimation
                ? StoryAnimation(
                    storyCell: widget.cells[initialPage],
                    cells: widget.cells,
                    index: _storiesController.id!,
                    cellHeight: widget.cellHeight,
                    cellWidht: widget.cellWidht,
                    dy: y,
                    dx: x,
                    animation: animation,
                    statusBarHeigth: statusBarHeigth,
                    sizeModel: sizeModel,
                    duration: widget.imageSwitchDuration,
                    reverseDuration: widget.reverseImageSwitchDuration,
                  )
                : const SizedBox.shrink();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListViewObserver(
      controller: _observerController,
      child: ListView.builder(
        key: _key,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.cells.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              GestureDetector(
                onTap: () {
                  _onStorySwipeClicked(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0).copyWith(
                      left: index == 0 ? 16 : 5,
                      right: index == widget.cells.length - 1 ? 16 : 5),
                  child: Container(
                    width: widget.cellWidht != null ? widget.cellWidht! : 80,
                    height: widget.cellHeight != null ? widget.cellHeight! : 80,
                    padding: const EdgeInsets.all(1),
                    decoration: widget.allowBorder
                        ? widget.cells[index].watched
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: const Color(0xFFB6BCC3).withOpacity(0.5),
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF4C43C),
                                    Color(0xFF2AB67C),
                                  ],
                                ),
                              )
                        : null,
                    child: Container(
                      width: widget.cellWidht != null ? widget.cellWidht! : 79,
                      height:
                          widget.cellHeight != null ? widget.cellHeight! : 79,
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
              ),
            ],
          );
        },
      ),
    );
  }
}
