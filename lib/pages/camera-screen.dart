import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quatrace/pages/auth.dart';
import 'package:quatrace/pages/statistics.dart';
import 'package:quatrace/utils/api-util.dart';
import 'package:camera/camera.dart';
import 'package:quatrace/utils/push-util.dart';
import 'package:quatrace/utils/widget-utils.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  String _loadingMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadingMessage = "Initializing...";
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _initializeCamera() async {
    List<CameraDescription> _cameras = await availableCameras();
    setState(() {
      _controller = CameraController(_cameras[1], ResolutionPreset.veryHigh);
    });
    await _controller.initialize();
    setState(() {
      this._isLoading = false;
    });
  }

  Widget _buildCameraPreview(context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: _controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller), //cameraPreview
        ),
      ),
    );
  }

  void onCaptureButtonPressed(BuildContext context) async {
    //on camera button press
    try {
      setState(() {
        _loadingMessage = "Processing image...";
        _isLoading = true;
      });
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.png',
      );
      await _controller.takePicture(path); //take photo
      final String fcmKey = await PushNotifications(context).register();
      await APIUtil().upload(File(path), fcmKey);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AuthPage(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _buildBottomNavigationBar(context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FloatingActionButton(
            splashColor: Colors.amberAccent,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.camera_alt,
              size: 28.0,
              color: Colors.black,
            ),
            onPressed: () {
              onCaptureButtonPressed(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? WidgetUtils().generateLoader(context, _loadingMessage)
        : SafeArea(
            child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                extendBody: true,
                body: Stack(
                  children: <Widget>[_buildCameraPreview(context)],
                ),
                bottomNavigationBar: _buildBottomNavigationBar(context)),
          );
  }
}
