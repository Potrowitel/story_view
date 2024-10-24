import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/story_screen.dart';
import 'package:stories/src/widgets/multitouch.dart';
import 'package:stories/src/widgets/story_animation.dart';
import 'package:stories/src/widgets/swipe.dart';
import 'package:stories/stories.dart';

typedef ActionButtonClicked = void Function();

class Stories extends StatefulWidget {
  final List<StoryCell> cells;
  final int timeout;
  final Widget? timeoutWidget;
  final double? cellHeight;
  final double? cellWidth;
  final bool exitButton;
  final Color? statusBarColor;
  final bool allowBorder;
  final bool allowAnimation;
  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final Duration imageSwitchDuration;
  final Duration reverseImageSwitchDuration;
  final bool allowDragg;
  final Color underBorderColor;
  final bool isPopped;
  final Function(int id, int sroryId)? onWatched;
  final double padding;
  final BaseCacheManager? cacheManager;
  final Map<String, String>? headers;

  const Stories({
    Key? key,
    required this.cells,
    this.timeout = 20,
    this.timeoutWidget,
    this.cellHeight,
    this.cellWidth,
    this.statusBarColor,
    this.onWatched,
    this.exitButton = true,
    this.allowBorder = true,
    this.allowAnimation = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.imageSwitchDuration = const Duration(milliseconds: 200),
    this.reverseImageSwitchDuration = const Duration(milliseconds: 200),
    this.allowDragg = true,
    this.underBorderColor = Colors.white,
    this.isPopped = true,
    this.padding = 5,
    this.cacheManager,
    this.headers,
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
  final GlobalKey _key = GlobalKey();
  late int _currentPage;
  late double x;
  int currentItemIndex = 0;
  late int countItemOnScreen;
  late StoryAnimationController storyAnimationController;
  late StoriesWatchedController watchedController;
  void onPageComplete(int index) {
    if (_pageController.page == widget.cells.length - 1) {
      if (!mounted) return;
      // if (Navigator.canPop(context)) {
      scrollToItem(index);
      Navigator.of(context, rootNavigator: true).pop();
      // }
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
        (MediaQuery.of(context).size.width - widget.cellWidth! + 7) * 0.00001 +
            widget.cellWidth! -
            6;
    countItemOnScreen =
        (MediaQuery.of(context).size.width / (itemWidth + widget.padding * 2))
            .floor();
    double offset = (itemWidth + widget.padding) * _storiesController.id!;
    if (widget.cells.length >= 10 &&
        _storiesController.id! >= widget.cells.length - countItemOnScreen) {
      double offset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      x = ((_storiesController.id!) * (widget.cellWidth! + widget.padding) +
              20) -
          offset;
    } else if (_storiesController.id! + 1 > countItemOnScreen &&
        widget.cells.length <= 10) {
      double offset = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      x = ((_storiesController.id!) * (widget.cellWidth! + widget.padding) +
              20) -
          offset;
    } else if (currentItemIndex <= _storiesController.id! &&
        _storiesController.id! < countItemOnScreen + currentItemIndex) {
      x = ((_storiesController.id!) * (widget.cellWidth! + widget.padding) +
              20) -
          _scrollController.offset;
    } else {
      _scrollController.animateTo(offset,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
      x = ((_storiesController.id!) * (widget.cellWidth! + widget.padding) +
              20) -
          offset;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _storiesController = StoriesController();
    _scrollController.addListener(() {
      offsetListener();
    });
    watchedController = StoriesWatchedController(List.generate(
        widget.cells.length, (index) => widget.cells[index].watched));
    watchedController.addListener(
      () {
        if (!mounted) return;
        setState(() {});
      },
    );

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
    currentItemIndex = ((_scrollController.offset + widget.padding * 2) /
            (widget.cellWidth! + widget.padding * 2))
        .floor();
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
    x = ((_storiesController.id!) * (widget.cellWidth! + widget.padding) + 20) -
        _scrollController.offset;
    storyAnimationController = StoryAnimationController(
      id: initialPage,
      index: 0,
      heigth: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      dy: widget.cells[initialPage].stories.first.meadiaType == MediaType.video
          ? 0.0
          : 0,
      // MediaQuery.of(context).viewPadding.top -
      //     MediaQuery.of(context).viewPadding.bottom,
      dx: 0,
      isOpen: true,
    );

    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
          opaque: false,
          transitionDuration: widget.transitionDuration,
          reverseTransitionDuration: widget.reverseTransitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnlyOnePointerRecognizerWidget(
              child: StorySwipe(
                cacheManager: widget.cacheManager,
                headers: widget.headers,
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
                storyAnimationController: storyAnimationController,
                allowDragg: widget.allowDragg,
                watchedController: watchedController,
                isPopped: widget.isPopped,
              ),
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (animation.isCompleted) {
              return child;
            }
            double statusBarHeigth = MediaQuery.of(context).viewPadding.top;
            return widget.allowAnimation
                ? StoryAnimation(
                    cacheManager: widget.cacheManager,
                    headers: widget.headers,
                    storyCell: widget.cells[initialPage],
                    cells: widget.cells,
                    index: _storiesController.id!,
                    cellHeight: widget.cellHeight,
                    cellWidth: widget.cellWidth,
                    dy: y,
                    dx: x,
                    animation: animation,
                    statusBarHeigth: statusBarHeigth,
                    storyAnimationController: storyAnimationController,
                    duration: widget.imageSwitchDuration,
                    reverseDuration: widget.reverseImageSwitchDuration,
                  )
                : const SizedBox.shrink();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.cellHeight,
      child: ListView.separated(
        key: _key,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.cells.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              GestureDetector(
                onTap: () {
                  _onStorySwipeClicked(index);
                },
                child: Container(
                  width: widget.cellWidth ?? 80,
                  height: widget.cellHeight ?? 80,
                  padding: const EdgeInsets.all(2),
                  decoration: widget.allowBorder
                      ? watchedController.watched(index)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xFFB6BCC3).withOpacity(0.5),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
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
                    width: widget.cellWidth ?? 79,
                    height: widget.cellHeight ?? 79,
                    padding:
                        widget.allowBorder ? const EdgeInsets.all(2) : null,
                    decoration: widget.allowBorder
                        ? BoxDecoration(
                            color: widget.underBorderColor,
                            borderRadius: BorderRadius.circular(13),
                          )
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: widget.cells[index].iconUrl.contains('http')
                          ? CachedNetworkImage(
                              imageUrl: widget.cells[index].iconUrl,
                              fit: BoxFit.contain,
                              cacheManager: widget.cacheManager,
                              httpHeaders: widget.headers,
                              errorWidget: (context, url, error) {
                                return Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white);
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  width: widget.cellWidth ?? 70,
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
                            )
                          : Container(
                              width: widget.cellWidth ?? 70,
                              height: widget.cellHeight ?? 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image:
                                      AssetImage(widget.cells[index].iconUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: widget.padding),
      ),
    );
  }
}
