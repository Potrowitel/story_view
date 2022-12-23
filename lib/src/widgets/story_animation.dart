import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../stories.dart';

class StoryAnimation extends StatefulWidget {
  final StoryCell storyCell;
  final List<StoryCell> cells;
  final int index;
  final double? cellHeight;
  final double? cellWidht;
  final GlobalKey cellKey;
  final Animation<double> animation;

  const StoryAnimation({
    Key? key,
    required this.storyCell,
    required this.index,
    required this.cells,
    this.cellHeight,
    this.cellWidht,
    required this.cellKey,
    required this.animation,
  }) : super(key: key);

  @override
  State<StoryAnimation> createState() => _StoryAnimationState();
}

class _StoryAnimationState extends State<StoryAnimation> {
  RenderBox? box;
  Offset? position;
  double? y;
  double? x;
  Animation<double>? anim;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    box = widget.cellKey.currentContext?.findRenderObject() as RenderBox;
    position = box!.localToGlobal(Offset.zero);
    y = position!.dy;
    x = position!.dx;
    anim = widget.animation.drive(Tween(begin: 1.0, end: 0.0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: widget.animation,
          builder: (context, child) {
            return Stack(
              children: [
                Positioned(
                  top: anim!.value > 0.01
                      ? y! * anim!.value
                      : y! * anim!.value + x!,
                  left: anim!.value > 0.01
                      ? x! * anim!.value
                      : x! * anim!.value + x!,
                  child: FadeTransition(
                    opacity: anim!,
                    child: anim!.value < 0.3
                        ? CachedNetworkImage(
                            imageUrl: widget.storyCell.stories.first.url,
                            width: (MediaQuery.of(context).size.width - 80) *
                                    widget.animation.value +
                                80,
                            height: (MediaQuery.of(context).size.height - 80) *
                                    widget.animation.value +
                                80,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5.0).copyWith(
                                left: widget.index == 0 ? 16 : 5,
                                right: widget.index == widget.cells.length - 1
                                    ? 16
                                    : 5),
                            child: Container(
                              key: _key,
                              width: widget.cellWidht != null
                                  ? (MediaQuery.of(context).size.width -
                                              widget.cellWidht! +
                                              10.0) *
                                          widget.animation.value +
                                      widget.cellHeight!
                                  : (MediaQuery.of(context).size.width - 80) *
                                          widget.animation.value +
                                      80,
                              height: widget.cellHeight != null
                                  ? (MediaQuery.of(context).size.height -
                                              widget.cellHeight! +
                                              10.0) *
                                          widget.animation.value +
                                      widget.cellHeight!
                                  : (MediaQuery.of(context).size.height - 80) *
                                          widget.animation.value +
                                      80,
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                width: widget.cellWidht != null
                                    ? widget.cellWidht! + 9
                                    : 79,
                                height: widget.cellHeight != null
                                    ? widget.cellHeight! + 9
                                    : 79,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.cells[widget.index].iconUrl,
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                ),
              ],
            );
          }),
    );
  }
}
