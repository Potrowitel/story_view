import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/widgets/story_background.dart';

import '../../stories.dart';

class StoryAnimation extends StatefulWidget {
  final StoryCell storyCell;
  final List<StoryCell> cells;
  final int index;
  final double? cellHeight;
  final double? cellWidht;
  final double dy;
  final double dx;
  final Animation<double> animation;
  final double statusBarHeigth;
  final StoryAnimationController storyAnimationController;
  final Duration duration;
  final Duration reverseDuration;

  const StoryAnimation({
    Key? key,
    required this.storyCell,
    required this.index,
    required this.cells,
    this.cellHeight,
    this.cellWidht,
    required this.dy,
    required this.dx,
    required this.animation,
    required this.statusBarHeigth,
    required this.storyAnimationController,
    required this.duration,
    required this.reverseDuration,
  }) : super(key: key);

  @override
  State<StoryAnimation> createState() => _StoryAnimationState();
}

class _StoryAnimationState extends State<StoryAnimation>
    with TickerProviderStateMixin {
  late Animation<double> dyAnimation;
  late Animation<double> dxAnimation;
  late Animation<double> possitionAnimation;
  late Animation<double> backgroundOpacity;
  late Animation<double> firstAnimationImage;
  late Animation<double> secondAnimationImage;
  late Animation<double> heigthAnim;
  late Animation<double> widthAnim;
  late AnimationController animation;
  late double height = widget.cellHeight!;
  late double width = widget.cellWidht!;
  Widget? storyPreview;

  @override
  void initState() {
    dyAnimation = widget.animation.drive(Tween(
            begin: widget.dy + 5,
            end: widget.storyAnimationController.isOpen
                ? widget.storyAnimationController.dy
                : widget
                            .cells[widget.storyAnimationController.id]
                            .stories[widget.storyAnimationController.index]
                            .meadiaType ==
                        MediaType.video
                    ? widget.storyAnimationController.dy
                    : widget.storyAnimationController.dy + 25)
        .chain(CurveTween(curve: Curves.easeInOut)));
    dxAnimation = widget.animation.drive(Tween(
            begin: widget.dx,
            end: widget.storyAnimationController.isOpen
                ? widget.storyAnimationController.dx
                : widget
                            .cells[widget.storyAnimationController.id]
                            .stories[widget.storyAnimationController.index]
                            .meadiaType ==
                        MediaType.video
                    ? widget.storyAnimationController.dx
                    : widget.storyAnimationController.dx + 26)
        .chain(CurveTween(curve: Curves.easeInOut)));

    backgroundOpacity = widget.animation.drive(Tween<double>(
            begin: 0, end: widget.storyAnimationController.isOpen ? 1 : 0.6)
        .chain(CurveTween(curve: Curves.easeInOut)));

    heigthAnim = widget.animation.drive(Tween(
            begin: widget.cellHeight! - 16,
            end: widget.storyAnimationController.heigth)
        .chain(CurveTween(curve: Curves.easeInOut)));
    widthAnim = widget.animation.drive(Tween(
            begin: widget.cellWidht! - 5,
            end: widget.storyAnimationController.width)
        .chain(CurveTween(curve: Curves.easeInOut)));
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

    firstAnimationImage = animation.drive(Tween(begin: 0, end: 1));
    secondAnimationImage = animation.drive(Tween(begin: 1, end: 0));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storyPreview = CachedNetworkImage(
        imageUrl: widget.cells[widget.storyAnimationController.id]
            .stories[widget.storyAnimationController.index].url,
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
    });
    super.initState();
  }

  @override
  void dispose() {
    animation.dispose();
    storyPreview = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:
            const Color(0xFF2E445B).withOpacity(backgroundOpacity.value),
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
                          // print('id ${widget.storyAnimationController.id}');
                          // print(
                          //     'index ${widget.storyAnimationController.index}');
                          return Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.bottomCenter,
                            children: [
                              AnimatedOpacity(
                                opacity: firstAnimationImage.value,
                                duration: const Duration(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      40 * widget.animation.value),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.cells[widget.index].iconUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: const Duration(),
                                opacity: secondAnimationImage.value,
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
                                          child: StoryBackground(
                                            type: widget
                                                .cells[widget
                                                    .storyAnimationController
                                                    .id]
                                                .stories[widget
                                                    .storyAnimationController
                                                    .index]
                                                .backType,
                                            url: widget
                                                .cells[widget
                                                    .storyAnimationController
                                                    .id]
                                                .stories[widget
                                                    .storyAnimationController
                                                    .index]
                                                .backType,
                                            gradientStart: widget
                                                .cells[widget
                                                    .storyAnimationController
                                                    .id]
                                                .stories[widget
                                                    .storyAnimationController
                                                    .index]
                                                .gradientStart,
                                            gradientEnd: widget
                                                .cells[widget
                                                    .storyAnimationController
                                                    .id]
                                                .stories[widget
                                                    .storyAnimationController
                                                    .index]
                                                .gradientEnd,
                                          ),
                                        ),
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
                                                          .gradientStart!,
                                                      widget
                                                          .cells[widget
                                                              .storyAnimationController
                                                              .id]
                                                          .stories[widget
                                                              .storyAnimationController
                                                              .index]
                                                          .gradientEnd!,
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
