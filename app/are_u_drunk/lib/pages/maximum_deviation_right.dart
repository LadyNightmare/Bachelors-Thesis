import 'package:are_u_drunk/pages/info_page.dart';
import 'package:are_u_drunk/pages/onset_degrees_left.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CheckMaximumDeviationRightPage extends InfoPage {

  final String title = "Maximum deviation right";
  final String description = "Press to start checking the maximum deviation right. Look to your right to the maximum deviation.";
  final String image = "assets/maxright.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckMaximumDeviationRightVideo(camera: camera);
  }

}

class CheckMaximumDeviationRightVideo extends TakePictureScreen {
  final CameraDescription camera;

  const CheckMaximumDeviationRightVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckMaximumDeviationRight createState() => TakeVideoCheckMaximumDeviationRight();
}

class TakeVideoCheckMaximumDeviationRight extends TakeVideoScreenState {
  @override
  Widget getNextPage(String image) {
    return DisplayVideoMaximumDeviationRight(image: image);
  }

}

class DisplayVideoMaximumDeviationRight extends VideoPlayerScreen {

  final String image;

  const DisplayVideoMaximumDeviationRight({Key? key, required this.image}) : super(path: image, endpoint: "maximumright");

  @override
  Widget getNextPage() {
    return CheckOnsetDegreesLeftPage();
  }

}