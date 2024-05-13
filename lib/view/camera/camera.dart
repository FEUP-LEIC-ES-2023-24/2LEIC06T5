import 'dart:async';
import 'dart:io';

import 'package:flutter_better_camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pagepal/view/camera/widgets/photo_preview.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({required this.camera, super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

IconData getCameraLensIcon(CameraLensDirection? direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    case null:
      return Icons.camera;
  }
}

class TakePictureScreenState extends State<TakePictureScreen>
    with WidgetsBindingObserver {
  late CameraController? _controller;
  String? imagePath;
  FlashMode flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    initializeController();
  }

  Future<void> initializeController() async {
    await _controller!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized!) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black, border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller!.value.isInitialized!) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: CameraPreview(_controller!),
      );
    }
  }

  Widget _captureControlRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
            onPressed: _controller != null && _controller!.value.isInitialized!
                ? () => onTakePictureButtonPressed()
                : () {},
            icon: const Icon(Icons.camera_alt))
      ],
    );
  }

  void onTakePictureButtonPressed() async {
    String? filePath = await takePicture();
    if (mounted) {
      setState(() {
        imagePath = filePath;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FutureBuilder<String?>(
            future: Future.value(imagePath),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  return PhotoPreviewer(filePath: snapshot.data!);
                } else {
                  return const CircularProgressIndicator.adaptive();
                }
              } else {
                return const Text("error");
              }
            },
          ),
        ),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String?> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_controller!.value.isTakingPicture!) {
      return null;
    }

    await _controller!.takePicture(filePath);
    return filePath;
  }
}
