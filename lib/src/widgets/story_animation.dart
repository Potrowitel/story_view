import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/widgets/story_background.dart';

import '../../stories.dart';

class StoryAnimation extends StatefulWidget {
  final StoryCell storyCell;
  final List<StoryCell> cells;
  final int index;
  final double? cellHeight;
  final double? cellWidth;
  final double dy;
  final double dx;
  final Animation<double> animation;
  final double statusBarHeigth;
  final StoryAnimationController storyAnimationController;
  final Duration duration;
  final Duration reverseDuration;
  final BaseCacheManager? cacheManager;
  final Map<String, String>? headers;

  const StoryAnimation({
    Key? key,
    required this.storyCell,
    required this.index,
    required this.cells,
    this.cellHeight,
    this.cellWidth,
    required this.dy,
    required this.dx,
    required this.animation,
    required this.statusBarHeigth,
    required this.storyAnimationController,
    required this.duration,
    required this.reverseDuration,
    this.cacheManager,
    this.headers,
  }) : super(key: key);

  @override
  State<StoryAnimation> createState() => _StoryAnimationState();
}

class _StoryAnimationState extends State<StoryAnimation>
    with TickerProviderStateMixin {
  late Animation<double> dyAnimation;
  late Animation<double> dxAnimation;
  late Animation<double> borderAnimation;
  late Animation<double> backgroundOpacity;
  late Animation<double> firstAnimationImage;
  late Animation<double> secondAnimationImage;
  late Animation<double> heigthAnim;
  late Animation<double> widthAnim;
  late AnimationController animation;
  late double height = widget.cellHeight ?? 0;
  late double width = widget.cellWidth ?? 0;
  Widget? storyPreview;
  Widget? storiesPreview;
  Widget? storyBackground;

  @override
  void initState() {
    dyAnimation = widget.animation.drive(
        Tween(begin: widget.dy + 4, end: widget.storyAnimationController.dy)
            .chain(CurveTween(curve: Curves.easeInOut)));
    dxAnimation = widget.animation.drive(
        Tween(begin: widget.dx, end: widget.storyAnimationController.dx)
            .chain(CurveTween(curve: Curves.easeInOut)));

    backgroundOpacity = widget.animation.drive(Tween<double>(
            begin: 0, end: widget.storyAnimationController.isOpen ? 1 : 0.6)
        .chain(CurveTween(curve: Curves.easeInOut)));

    heigthAnim = widget.animation.drive(Tween(
            begin: widget.cellHeight! - 8,
            end: widget.storyAnimationController.heigth)
        .chain(CurveTween(curve: Curves.easeInOut)));
    widthAnim = widget.animation.drive(Tween(
            begin: widget.cellWidth! - 8,
            end: widget.storyAnimationController.width)
        .chain(CurveTween(curve: Curves.easeInOut)));
    borderAnimation = widget.animation.drive(Tween(begin: 1, end: 0));
    animation = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );
    if (widget.animation.value == 1) {
      animation.animateTo(
        1,
        curve: Curves.easeInOut,
      );
    } else {
      animation.reverse(from: 1);
    }

    firstAnimationImage = widget.animation.drive(Tween(begin: 1, end: 0));
    secondAnimationImage = animation.drive(Tween(begin: 1, end: 0));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.cells[widget.storyAnimationController.id]
          .stories[widget.storyAnimationController.index].url
          .contains('http')) {
        storyPreview = CachedNetworkImage(
          imageUrl: widget.cells[widget.storyAnimationController.id]
              .stories[widget.storyAnimationController.index].url,
          cacheManager: widget.cacheManager,
          httpHeaders: widget.headers,
          errorWidget: (context, url, error) {
            return const Center(
              child: Text(
                'Проверьте интернет соединение',
                style: TextStyle(color: Colors.white),
              ),
            );
          },
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: Colors.blueGrey,
                  strokeWidth: 3.0,
                ),
              ),
            );
          },
          imageBuilder: (context, imageProvider) {
            if (widget.cells[widget.storyAnimationController.id]
                    .stories[widget.storyAnimationController.index].backType !=
                null) {
              return Image(
                alignment: Alignment.bottomCenter,
                image: imageProvider,
                fit: BoxFit.fitWidth,
              );
            }
            return ClipRRect(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        if (widget.cells[widget.storyAnimationController.id]
                .stories[widget.storyAnimationController.index].backType !=
            null) {
          storyPreview = Image(
            alignment: Alignment.bottomCenter,
            image: AssetImage(widget.cells[widget.storyAnimationController.id]
                .stories[widget.storyAnimationController.index].url),
            fit: BoxFit.fitWidth,
          );
        } else {
          storyPreview = ClipRRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget
                            .cells[widget.storyAnimationController.id]
                            .stories[widget.storyAnimationController.index]
                            .url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget
                          .cells[widget.storyAnimationController.id]
                          .stories[widget.storyAnimationController.index]
                          .url),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
      storiesPreview = widget.cells[widget.index].iconUrl.contains('http')
          ? CachedNetworkImage(
              imageUrl: widget.cells[widget.index].iconUrl,
              cacheManager: widget.cacheManager,
              httpHeaders: widget.headers,
              fit: BoxFit.cover,
            )
          : Container(
              width: widget.cellWidth ?? 70,
              height: widget.cellHeight ?? 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(widget.cells[widget.index].iconUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
      storyBackground = StoryBackground(
        cacheManager: widget.cacheManager,
        headers: widget.headers,
        type: widget.cells[widget.storyAnimationController.id]
            .stories[widget.storyAnimationController.index].backType,
        url: widget.cells[widget.storyAnimationController.id]
            .stories[widget.storyAnimationController.index].backType,
        gradientStart: widget.cells[widget.storyAnimationController.id]
            .stories[widget.storyAnimationController.index].gradientStart,
        gradientEnd: widget.cells[widget.storyAnimationController.id]
            .stories[widget.storyAnimationController.index].gradientEnd,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    storyPreview = null;
    storiesPreview = null;
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
      child: Scaffold(
        backgroundColor: const Color(0xFF2E445B).withOpacity(
            widget.storyAnimationController.opacity != null
                ? widget.storyAnimationController.opacity ??
                    0 * backgroundOpacity.value
                : backgroundOpacity.value),
        body: Stack(
          children: [
            AnimatedBuilder(
                animation: widget.animation,
                builder: (context, child) {
                  height = heigthAnim.value;
                  width = widthAnim.value;
                  return const SizedBox.shrink();
                }),
            Stack(
              children: [
                Positioned(
                  top: dyAnimation.value,
                  left: dxAnimation.value,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.bottomCenter,
                            children: [
                              AnimatedOpacity(
                                opacity: firstAnimationImage.value,
                                duration: const Duration(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      13 * borderAnimation.value),
                                  child: storiesPreview,
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(),
                                opacity: secondAnimationImage.value * 3 > 1
                                    ? 1
                                    : secondAnimationImage.value * 3 < 0
                                        ? 0
                                        : secondAnimationImage.value * 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      40 * widget.animation.value),
                                  child: Stack(
                                    children: [
                                      if (widget
                                              .cells[widget
                                                  .storyAnimationController.id]
                                              .stories[widget
                                                  .storyAnimationController
                                                  .index]
                                              .backType !=
                                          null)
                                        SizedBox(
                                            height: double.infinity,
                                            width: double.infinity,
                                            child: storyBackground),
                                      if (widget
                                              .cells[widget
                                                  .storyAnimationController.id]
                                              .stories[widget
                                                  .storyAnimationController
                                                  .index]
                                              .meadiaType ==
                                          MediaType.image)
                                        SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: storyPreview,
                                        ),
                                      if (widget
                                              .cells[widget
                                                  .storyAnimationController.id]
                                              .stories[widget
                                                  .storyAnimationController
                                                  .index]
                                              .meadiaType ==
                                          MediaType.video)
                                        Container(
                                          width: width,
                                          height: height,
                                          decoration: widget
                                                          .cells[widget
                                                              .storyAnimationController
                                                              .id]
                                                          .stories[widget
                                                              .storyAnimationController
                                                              .index]
                                                          .gradientStart ==
                                                      null ||
                                                  widget
                                                          .cells[widget
                                                              .storyAnimationController
                                                              .id]
                                                          .stories[widget
                                                              .storyAnimationController
                                                              .index]
                                                          .gradientEnd ==
                                                      null
                                              ? null
                                              : BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      widget
                                                              .cells[widget
                                                                  .storyAnimationController
                                                                  .id]
                                                              .stories[widget
                                                                  .storyAnimationController
                                                                  .index]
                                                              .gradientStart ??
                                                          Colors.black,
                                                      widget
                                                              .cells[widget
                                                                  .storyAnimationController
                                                                  .id]
                                                              .stories[widget
                                                                  .storyAnimationController
                                                                  .index]
                                                              .gradientEnd ??
                                                          Colors.black,
                                                    ],
                                                  ),
                                                ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
