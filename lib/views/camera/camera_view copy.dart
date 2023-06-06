import 'package:flutter/material.dart';
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
            // If the Future is complete, display the preview.
            return AspectRatio(
                aspectRatio: MediaQuery.of(context).size.aspectRatio,
                // aspectRatio: 1 / 1,
                child: Stack(fit: StackFit.expand, children: [
                  CameraPreview(_controller),
                  cameraOverlay(
                      padding: 80, aspectRatio: 1, color: Color(0x55000000))
                ]));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            File file = File(image.path);

            final assessment = await uploadImage(file);
            final assessmentInt = int.parse(assessment);
            print('assessment');
            print(assessment);
            final assessmentText = getAssessmentText(assessmentInt);

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
        child: const Icon(Icons.camera_alt),
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

// A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Stack(children: [
//         Image.file(File(imagePath)),
//       ]),
//     );
//   }
// }
