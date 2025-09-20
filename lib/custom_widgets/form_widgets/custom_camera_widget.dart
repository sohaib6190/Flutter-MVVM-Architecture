part of 'form_widgets.dart';

class CustomCameraCompassWidget extends StatefulWidget {
  const CustomCameraCompassWidget({
    super.key,
    required this.imagesWithHeading,
    required this.onImageUpdate,
    this.mediaUrls,
    this.allowVideo = false,
    this.useCompass = true,
    this.hasButtonIcon = true,
    this.buttonColor,
    this.buttonTitle,
  });

  final List<Map<String, dynamic>> imagesWithHeading;
  final void Function(List<Map<String, dynamic>>) onImageUpdate;
  final List<MediaUrl>? mediaUrls;
  final bool allowVideo;
  final bool useCompass;
  final bool hasButtonIcon;
  final Color? buttonColor;
  final String? buttonTitle;

  @override
  State<CustomCameraCompassWidget> createState() =>
      _CustomCameraCompassWidgetState();
}

class _CustomCameraCompassWidgetState extends State<CustomCameraCompassWidget> {
  late List<Map<String, dynamic>> imagesWithHeading;
  bool isNetworkImagesLoading = false;

  @override
  initState() {
    super.initState();
    imagesWithHeading = widget.imagesWithHeading;
    _fetchImagesFromNetwork(widget.mediaUrls);
  }

  Future<void> _fetchImagesFromNetwork(List<MediaUrl>? mediaUrls) async {
    if (mediaUrls != null) {
      setState(() => isNetworkImagesLoading = true);
      List<Map<String, dynamic>> tempImagesWithHeading = [];
      for (var media in mediaUrls) {
        try {
          final response =
              await http.get(Uri.parse('${AppApis.baseUrl}${media.url}'));
          if (response.statusCode == 200) {
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/${media.url?.split('/').last}';
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);

            tempImagesWithHeading.add({
              'image': XFile(file.path),
              'heading': -101010.101010,
              'isVideo': isVideo(file.path),
            });
          }
        } catch (e) {
          debugPrint('Failed to download image: $e');
        }
      }

      setState(() {
        imagesWithHeading = tempImagesWithHeading;
        isNetworkImagesLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onImageUpdate(imagesWithHeading);
    });
  }

  void _handleMediaCapture(XFile file, double heading, bool isVideo) {
    setState(() {
      imagesWithHeading
          .add({'image': file, 'heading': heading, 'isVideo': isVideo});
    });
    widget.onImageUpdate(imagesWithHeading);
  }

  Future<void> _pickMultipleMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: widget.allowVideo ? FileType.media : FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        imagesWithHeading.addAll(
          result.paths.map((path) => {
                'image': XFile(path!),
                'heading': -101010.101010,
                'isVideo': isVideo(path),
              }),
        );
      });
      widget.onImageUpdate(imagesWithHeading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          onTap: () => _showImageOptions(context),
          padding: const EdgeInsets.all(12),
          radius: 12,
          title: widget.buttonTitle ?? translate(context, 'geotagging'),
          fontColor: context.monochromeColor,
          iconColor: context.monochromeColor,
          hasIcon: widget.hasButtonIcon,
          icon: AppIcons().add,
          iconSize: 17,
          fontSize: 15,
          buttonColor: widget.buttonColor ??
              (context.isDarkTheme
                  ? AppColorTheme().secondary
                  : AppColorTheme().white),
        ),
        if (imagesWithHeading.isNotEmpty ||
            widget.mediaUrls?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: isNetworkImagesLoading
                  ? List.generate(widget.mediaUrls?.length ?? 0, (i) {
                      return ShimmerWidget.fromColors(
                        baseColor: context.shimmerBaseColor,
                        highlightColor: context.shimmerHighlightColor,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColorTheme().white,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      );
                    })
                  : imagesWithHeading.map((media) {
                      final image = media['image'] as XFile;
                      final isVideo = media['isVideo'] as bool;
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          GestureDetector(
                            onTap: () => isVideo
                                ? showGeneralDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    barrierColor: AppColorTheme().black,
                                    transitionBuilder:
                                        (context, anim1, anim2, child) {
                                      return FadeTransition(
                                          opacity: anim1, child: child);
                                    },
                                    pageBuilder: (BuildContext buildContext,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation) {
                                      return FullScreenVideoDialog(
                                          videoUrl: '',
                                          videoFile: File(image.path));
                                    },
                                  )
                                : _showFullScreenMedia(context, image),
                            child:
                                _buildMediaThumbnail(File(image.path), isVideo),
                          ),
                          if (isVideo)
                            Positioned(
                              top: 27,
                              left: 30,
                              child: Icon(
                                AppIcons().playCircle,
                                color: AppColorTheme().white,
                              ),
                            ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => imagesWithHeading.remove(media)),
                            child: Icon(Icons.delete, size: 24),
                          ),
                        ],
                      );
                    }).toList(),
            ),
          ),
      ],
    );
  }

  void _showFullScreenMedia(BuildContext context, XFile image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColorTheme().black,
          child: Stack(
            children: [
              Center(
                child: Image.file(File(image.path)),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close,
                      color: context.monochromeColor, size: 30),
                  onPressed: () {
                    context.popPage();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: context.isDarkTheme
                  ? AppColorTheme().secondary
                  : AppColorTheme().lightBackground,
              leading: Icon(AppIcons().camera),
              title: Text(
                translate(context, 'camera'),
                style: context.bodyText,
              ),
              onTap: () {
                context.popPage();
                _openCamera(context);
              },
            ),
            ListTile(
              tileColor: context.isDarkTheme
                  ? AppColorTheme().secondary
                  : AppColorTheme().lightBackground,
              leading: Icon(AppIcons().photoLibrary),
              title: Text(
                translate(context, 'upload'),
                style: context.bodyText,
              ),
              onTap: () {
                context.popPage();
                _pickMultipleMedia();
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    context.pushPage(
      CameraScreen(
        onMediaCaptured: _handleMediaCapture,
        useCompass: widget.useCompass,
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final Function(XFile, double, bool) onMediaCaptured;
  final bool useCompass;

  const CameraScreen(
      {super.key, required this.onMediaCaptured, this.useCompass = true});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;

 
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  
  }

  @override
  void dispose() {
    _cameraController?.dispose();
 
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras![0], ResolutionPreset.high);

    try {
      await _cameraController?.initialize();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

Future<void> _captureImage() async {
  if (_isProcessing) return;
  setState(() => _isProcessing = true);

  try {
    final image = await _cameraController?.takePicture();
    if (image != null) {
      final imageFile = File(image.path);
      final img.Image? capturedImage =
          img.decodeImage(await imageFile.readAsBytes());

      if (capturedImage != null) {
        widget.onMediaCaptured(image, 0.0, false);
      } else {
        debugPrint('Failed to decode captured image.');
      }
    } else {
      debugPrint('Camera returned null image.');
    }
  } catch (e) {
    debugPrint('Error capturing image: $e');
  } finally {
    if (mounted) context.popPage();
    setState(() => _isProcessing = false);
  }
}

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
      
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: Icon(Icons.camera, size: 50),
              onPressed: _captureImage,
            ),
          ),
        ],
      ),
    );
  }
}

bool isVideo(String path) {
  return path.endsWith(".mp4") ||
      path.endsWith(".mov") ||
      path.endsWith(".3gp") ||
      path.endsWith(".mkv") ||
      path.endsWith(".webm") ||
      path.endsWith(".avi") ||
      path.endsWith(".flv") ||
      path.endsWith(".m4v") ||
      path.endsWith(".mpeg") ||
      path.endsWith(".mpg") ||
      path.endsWith(".wmv") ||
      path.endsWith(".ts");
}

Widget _buildMediaThumbnail(File file, bool isVideo) {
  return FutureBuilder<File?>(
    future: isVideo
        ? VideoCompress.getFileThumbnail(file.path)
        : Future.value(file),
    builder: (context, snapshot) {
      return snapshot.hasData
          ? Image.file(snapshot.data!, height: 80, width: 80, fit: BoxFit.cover)
          : ShimmerWidget.fromColors(
              baseColor: context.shimmerBaseColor,
              highlightColor: context.shimmerHighlightColor,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColorTheme().white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            );
    },
  );
}
class MediaUrl {
  final String? url;
  final String? type;

  MediaUrl({
    this.url,
    this.type,
  });

  MediaUrl copyWith({
    String? url,
    String? type,
  }) =>
      MediaUrl(
        url: url ?? this.url,
        type: type ?? this.type,
      );

  factory MediaUrl.fromJson(Map<String, dynamic> json) => MediaUrl(
        url: json["url"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
      };
}