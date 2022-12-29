import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
  final ScrollController scrollController;

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
    required this.scrollController,
  }) : super(key: key);

  @override
  State<StoryAnimation> createState() => _StoryAnimationState();
}

class _StoryAnimationState extends State<StoryAnimation> {
  late Animation<double> possitionAnimation;
  late Animation<double> backgroundOpacity;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();
    possitionAnimation = widget.animation.drive(Tween(begin: 0.8, end: 0.0));
    backgroundOpacity = widget.animation.drive(Tween(begin: 0, end: 0.6));
    sizeAnimation = widget.animation.drive(Tween(begin: 0.2, end: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xff2E445B).withOpacity(backgroundOpacity.value),
      body: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  top: (widget.dy + 8) * possitionAnimation.value,
                  left: widget.dx * possitionAnimation.value,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width -
                                widget.cellWidht! +
                                7) *
                            sizeAnimation.value +
                        widget.cellWidht! -
                        6,
                    height: (MediaQuery.of(context).size.height -
                                widget.cellHeight! +
                                17) *
                            sizeAnimation.value +
                        widget.cellHeight! -
                        16,
                    child: Container(
                      width: widget.cellWidht != null ? widget.cellWidht! : 79,
                      height:
                          widget.cellHeight != null ? widget.cellHeight! : 79,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            12 * possitionAnimation.value),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12 * possitionAnimation.value),
                        child: CachedNetworkImage(
                          imageUrl: widget.cells[widget.index].iconUrl,
                          errorWidget: (context, url, error) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black,
                            );
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
              ],
            );
          }),
    );
  }
}
