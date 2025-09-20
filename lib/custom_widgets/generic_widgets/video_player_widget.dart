part of 'generic_widgets.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  Future<File?> _downloadPartialVideo(String url) async {
    try {
      // Create a temporary directory for the partial video
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/partial_video.mp4';

      // Open a file for writing the downloaded content
      final file = File(filePath).openSync(mode: FileMode.write);

      final response = await http.get(
        Uri.parse(url),
        headers: {'Range': 'bytes=0-2000000'},
      );

      if (response.statusCode == 206 || response.statusCode == 200) {
        // Write the partial data to the file
        file.writeFromSync(response.bodyBytes);
        file.close();
        return File(filePath);
      } else {
        debugPrint('Failed to download partial video: ${response.statusCode}');
        file.close();
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading partial video: $e');
      return null;
    }
  }

  Future<File?> getThumbnail() async {
    // Download the first 1MB of the video
    final partialVideoFile = await _downloadPartialVideo(widget.videoUrl);

    if (partialVideoFile != null) {
      // Generate a thumbnail from the partial video
      final thumbnailFile = await VideoCompress.getFileThumbnail(
        partialVideoFile.path,
      );
      return thumbnailFile;
    }

    return null; // Return null if the partial file couldn't be downloaded
  }

  Widget _buildMediaThumbnail() {
    return FutureBuilder<File?>(
      future: getThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Image.file(
                snapshot.data!,
                height: double.maxFinite,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColorTheme().black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons().playCircle,
                  color: AppColorTheme().white,
                  size: 60,
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget(context);
        } else {
          return _buildErrorWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => _showFullScreenVideoDialog(context),
      child: _buildMediaThumbnail(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColorTheme().lightGrey,
      child: Center(
        child: Icon(
          AppIcons().videoError,
          color: AppColorTheme().greyshade1,
          size: 60,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return ShimmerWidget.fromColors(
      baseColor: context.shimmerBaseColor,
      highlightColor: context.shimmerHighlightColor,
      child: Container(
        color: AppColorTheme().white,
      ),
    );
  }

  void _showFullScreenVideoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColorTheme().black,
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FullScreenVideoDialog(videoUrl: widget.videoUrl);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FullScreenVideoDialog extends StatefulWidget {
  const FullScreenVideoDialog(
      {super.key, required this.videoUrl, this.videoFile});

  final String videoUrl;
  final File? videoFile;

  @override
  State<FullScreenVideoDialog> createState() => _FullScreenVideoDialogState();
}

class _FullScreenVideoDialogState extends State<FullScreenVideoDialog> {
  late VideoPlayerController _controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoFile != null
        ? VideoPlayerController.file(widget.videoFile!)
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _toggleMute() {
    setState(() {
      _controller.setVolume(_controller.value.volume == 0.0 ? 1.0 : 0.0);
    });
  }

  void _mute() {
    _controller.setVolume(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          if (_showControls) ...[
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _mute();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorTheme().black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      AppIcons().close,
                      color: AppColorTheme().white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? AppIcons().pause
                          : AppIcons().play,
                      color: AppColorTheme().white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: AppColorTheme().primary,
                        backgroundColor:
                            AppColorTheme().darkShimmerHighlightColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _toggleMute,
                    child: Icon(
                      _controller.value.volume > 0.0
                          ? AppIcons().volumeUp
                          : AppIcons().volumeOff,
                      color: AppColorTheme().white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
