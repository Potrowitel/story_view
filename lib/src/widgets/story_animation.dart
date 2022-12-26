import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../stories.dart';
import '../story_screen.dart';

class StoryAnimation extends StatefulWidget {
  final StoryCell storyCell;
  final List<StoryCell> cells;
  final int index;
  final double? cellHeight;
  final double? cellWidht;
  final List<GlobalKey> cellKey;
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

  late double height;
  late double width;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    box = widget.cellKey[widget.index].currentContext?.findRenderObject()
        as RenderBox;

    position = box!.localToGlobal(Offset.zero);
    height = box!.size.height;
    width = box!.size.width;
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
                      ? y! * anim!.value - 5
                      : y! * anim!.value + x! - 5,
                  left: anim!.value > 0.01
                      ? widget.index == 0
                          ? x! * anim!.value - 16
                          : x! * anim!.value + x! - 5 - x!
                      : x! * anim!.value - 5 - x!,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0).copyWith(
                        left: widget.index == 0 ? 16 : 5,
                        right:
                            widget.index == widget.cells.length - 1 ? 16 : 5),
                    child: Container(
                      key: _key,
                      width: (MediaQuery.of(context).size.width - width) *
                              widget.animation.value +
                          width,
                      height: (MediaQuery.of(context).size.height - height) *
                              widget.animation.value +
                          height,
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        width:
                            widget.cellWidht != null ? widget.cellWidht! : 80,
                        height:
                            widget.cellHeight != null ? widget.cellHeight! : 80,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
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
                ),
              ],
            );
          }),
    );
  }
}
