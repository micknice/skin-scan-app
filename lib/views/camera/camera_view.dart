import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skin_scan_app/utils/generics/assessment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_scan_app/constants/routes.dart';
import 'package:skin_scan_app/enums/menu_action.dart';
import 'package:skin_scan_app/services/auth/auth_service.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_bloc.dart';
import 'package:skin_scan_app/services/auth/bloc/auth_event.dart';
import 'package:skin_scan_app/services/cloud/cloud_job.dart';
import 'package:skin_scan_app/services/cloud/firebase_cloud_storage.dart';
import 'package:skin_scan_app/utils/dialogs/logout_dialog.dart';
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';

import 'package:dio/dio.dart';
import 'package:skin_scan_app/views/camera/assessment_view.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void _showGettingAssessmentDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10.0,
              ),
              Text('Please wait while your photo is assessed'),
            ],
          ));
        });
  }

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,

    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    Future<String> uploadImage(File file) async {
      print('uploadInvoked');
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await dio.post("https://tdd-skin.herokuapp.com/upload",
          data: formData);
      return response.data['type'].toString();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final mediaSize = MediaQuery.of(context).size;
            final scale =
                1 / (_controller.value.aspectRatio * mediaSize.aspectRatio);
            // If the Future is complete, display the preview.
            return Stack(children: [
              ClipRect(
                clipper: _MediaSizeClipper(mediaSize),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.center,
                  child: Stack(fit: StackFit.expand, children: [
                    CameraPreview(_controller),
                    Center(
                      child: cameraOverlay(
                          padding: 110,
                          aspectRatio: 1,
                          color: Color(0x55000000)),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Try to keep the camera still and keep the area of interest in focus in the centre of the screen',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            if (!mounted) return;

            _showGettingAssessmentDialog(context);

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            File file = File(image.path);

            final assessment = await uploadImage(file);

            final assessmentInt = int.parse(assessment);
            print('assessment');
            print(assessment);
            final assessmentText = getAssessmentText(assessmentInt);

            if (!mounted) return;
            Navigator.of(context).pop();
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path, assessmentText: assessmentText,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.white,),
      ),
    );
  }

  Widget cameraOverlay(
      {required double padding,
      required double aspectRatio,
      required Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
        )
      ]);
    });
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
