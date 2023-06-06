import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String assessmentText;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.assessmentText});

  @override
  Widget build(BuildContext context) {
    final scrnHeight = MediaQuery.of(context).size.height;
    final height = scrnHeight * 0.3;
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: height,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Text(assessmentText),
          ]),
        ),
      ),
    );
  }
}
