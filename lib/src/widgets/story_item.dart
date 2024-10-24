import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stories/src/controller.dart';
import 'package:stories/src/models/story.dart';
import 'package:stories/src/models/story_process.dart';
import 'package:stories/src/widgets/image.dart';
import 'package:stories/src/widgets/story_background.dart';
import 'package:stories/src/widgets/video.dart';

class StoryItem extends StatefulWidget {
  final int id;
  final Story story;
  final StoryController storyController;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? timeoutWidget;
  final int? timeout;
  final ValueChanged<StoryProcess> onProcess;
  final int globalId;
  final BaseCacheManager? cacheManager;
  final Map<String, String>? headers;
  // final Function(int id)? onLoading;
  // final Function(int id)? onDownloading;
  // final Function(int id)? onTimeout;
  // final Function(int id, Duration? duration)? onReady;
  // final Function(dynamic error)? onError;

  const StoryItem({
    required this.id,
    required this.story,
    required this.storyController,
    required this.onProcess,
    this.timeout,
    this.loadingWidget,
    this.errorWidget,
    this.timeoutWidget,
    this.cacheManager,
    // this.onError,
    // this.onLoading,
    // this.onReady,
    // this.onDownloading,
    // this.onTimeout,
    Key? key,
    required this.globalId,
    this.headers,
  }) : super(key: key);

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (widget.story.backType != null)
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: StoryBackground(
                type: widget.story.backType,
                url: widget.story.backUrl,
                gradientStart: widget.story.gradientStart,
                gradientEnd: widget.story.gradientEnd,
                cacheManager: widget.cacheManager,
                headers: widget.headers,
              ),
            ),
          if (widget.story.meadiaType == MediaType.image)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: ImageWiget(
                id: widget.id,
                key: UniqueKey(),
                story: widget.story,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                onProcess: widget.onProcess,
                cacheManager: widget.cacheManager,
                headers: widget.headers,
                // onReady: widget.onReady,
                // onLoading: widget.onLoading,
                // onError: widget.onError,
              ),
            ),
          if (widget.story.meadiaType == MediaType.video)
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: VideoWidget(
                id: widget.id,
                globalId: widget.globalId,
                key: UniqueKey(),
                story: widget.story,
                timeout: widget.timeout,
                timeoutWidget: widget.timeoutWidget,
                controller: widget.storyController,
                loadingWidget: widget.loadingWidget,
                onProcess: widget.onProcess,
                gradientStart: widget.story.gradientStart,
                gradientEnd: widget.story.gradientEnd,
                // onReady: widget.onReady,
                // onError: widget.onError,
                // onLoading: widget.onLoading,
              ),
            ),
        ],
      ),
    );
  }
}
