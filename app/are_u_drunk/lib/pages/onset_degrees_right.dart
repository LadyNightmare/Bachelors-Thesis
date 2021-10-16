import 'package:are_u_drunk/pages/info_page.dart';
import 'package:are_u_drunk/pages/result_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CheckOnsetDegreesRightPage extends InfoPage {

  final String title = "Onset 45 degrees right";
  final String description = "Press to start checking the onset 45 degrees right. Look 45 degrees to your right.";
  final String image = "assets/onsetright.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckOnsetDegreesRightVideo(camera: camera);
  }
}

class CheckOnsetDegreesRightVideo extends TakePictureScreen {

  final CameraDescription camera;

  const CheckOnsetDegreesRightVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckOnsetDegreesRight createState() => TakeVideoCheckOnsetDegreesRight();

}

class TakeVideoCheckOnsetDegreesRight extends TakeVideoScreenState {
  @override
  Widget getNextPage(String image) {
    return DisplayVideoOnsetRight(image: image);
  }

}

class DisplayVideoOnsetRight extends VideoPlayerScreen {

  final String image;

  const DisplayVideoOnsetRight({Key? key, required this.image}) : super(path: image, endpoint: "onsetright");

  @override
  Widget getNextPage() {
    failedClues = 0;
    return SoberPage();
  }

}