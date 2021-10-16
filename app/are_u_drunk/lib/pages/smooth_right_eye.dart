import 'package:are_u_drunk/pages/info_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'maximum_deviation_left.dart';

class CheckSmoothPursuitRightPage extends InfoPage {

  final String title = "Smooth pursuit right";
  final String description = "Press to start checking the smooth pursuit right. Look slowly and smoothly to your right.";
  final String image = "assets/smoothright.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckSmoothPursuitRightVideo(camera: camera);
  }

}

class CheckSmoothPursuitRightVideo extends TakePictureScreen {
  final CameraDescription camera;

  const CheckSmoothPursuitRightVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckSmoothPursuitRight createState() => TakeVideoCheckSmoothPursuitRight();
}

class TakeVideoCheckSmoothPursuitRight extends TakeVideoScreenState {
  @override
  Widget getNextPage(String image) {
    return DisplayVideoSmoothPursuitRight(image: image);
  }

}

class DisplayVideoSmoothPursuitRight extends VideoPlayerScreen {

  final String image;

  const DisplayVideoSmoothPursuitRight({Key? key, required this.image}) : super(path: image, endpoint: "smoothright");

  @override
  Widget getNextPage() {
    return CheckMaximumDeviationLeftPage();
  }

}