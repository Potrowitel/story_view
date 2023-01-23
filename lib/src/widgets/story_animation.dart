import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stories/src/models/stoty_size.dart';

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
  final StorySizeModel sizeModel;
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
    required this.sizeModel,
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
    dyAnimation = widget.animation.drive(
        Tween(begin: widget.dy + 5, end: widget.sizeModel.dy)
            .chain(CurveTween(curve: Curves.easeInOut)));
    dxAnimation = widget.animation.drive(Tween(
            begin: widget.dx,
            end: widget.sizeModel.isOpen
                ? widget.sizeModel.dx
                : widget.sizeModel.dx + 12)
        .chain(CurveTween(curve: Curves.easeInOut)));
    possitionAnimation = widget.animation.drive(Tween<double>(begin: 1, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut)));

    backgroundOpacity = widget.animation.drive(
        Tween<double>(begin: 0, end: widget.sizeModel.isOpen ? 1 : 0.6)
            .chain(CurveTween(curve: Curves.easeInOut)));

    heigthAnim = widget.animation.drive(Tween(
            begin: widget.cellHeight,
            end: widget.storyCell.stories.first.meadiaType == MediaType.video
                ? widget.sizeModel.heigth + widget.statusBarHeigth
                : widget.sizeModel.heigth)
        .chain(CurveTween(curve: Curves.easeInOut)));
    widthAnim = widget.animation.drive(
        Tween(begin: widget.cellWidht, end: widget.sizeModel.width)
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
        imageUrl: widget.storyCell.stories[widget.sizeModel.id].url,
        fit: BoxFit.contain,
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
    return Scaffold(
      backgroundColor: widget.storyCell.stories.first.meadiaType ==
                  MediaType.video ||
              widget.storyCell.stories.first.backType == null
          ? const Color(0xFF2E445B).withOpacity(backgroundOpacity.value)
          : widget.sizeModel.isOpen
              ? widget.storyCell.stories.first.gradientStart!
                  .withOpacity(backgroundOpacity.value)
              : const Color(0xFF2E445B).withOpacity(backgroundOpacity.value),
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
                                    32 * widget.animation.value),
                                child: CachedNetworkImage(
                                  height: height,
                                  width: width,
                                  imageUrl: widget.cells[widget.index].iconUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(),
                              opacity: secondAnimationImage.value,
                              child: Stack(
                                children: [
                                  if (widget
                                              .storyCell
                                              .stories[widget.sizeModel.id]
                                              .meadiaType ==
                                          MediaType.image ||
                                      widget
                                              .storyCell
                                              .stories[widget.sizeModel.id]
                                              .backType !=
                                          null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          32 * widget.animation.value),
                                      child: Container(
                                        width: width,
                                        height: height,
                                        alignment: Alignment.bottomCenter,
                                        child: storyPreview,
                                      ),
                                    ),
                                  if (widget
                                          .storyCell
                                          .stories[widget.sizeModel.id]
                                          .meadiaType ==
                                      MediaType.video)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(
                                          12 * (1 - widget.animation.value),
                                        ),
                                      ),
                                    )
                                ],
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
    );
  }
}
