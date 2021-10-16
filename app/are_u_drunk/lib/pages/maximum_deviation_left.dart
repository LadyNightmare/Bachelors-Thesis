import 'package:are_u_drunk/pages/info_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'maximum_deviation_right.dart';

class CheckMaximumDeviationLeftPage extends InfoPage {

  final String title = "Maximum deviation left";
  final String description = "Press to start checking the maximum deviation left. Look to your left to the maximum deviation.";
  final String image = "assets/maxleft.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckMaximumDeviationLeftVideo(camera: camera);
  }
}

class CheckMaximumDeviationLeftVideo extends TakePictureScreen {
  final CameraDescription camera;

  const CheckMaximumDeviationLeftVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckMaximumDeviationLeft createState() => TakeVideoCheckMaximumDeviationLeft();
}

class TakeVideoCheckMaximumDeviationLeft extends TakeVideoScreenState {
  @override
  Widget getNextPage(String image) {
    return DisplayVideoMaximumDeviationLeft(image: image);
  }

}

class DisplayVideoMaximumDeviationLeft extends VideoPlayerScreen {

  final String image;

  const DisplayVideoMaximumDeviationLeft({Key? key, required this.image}) : super(path: image, endpoint: "maximumleft");

  @override
  Widget getNextPage() {
    return CheckMaximumDeviationRightPage();
  }

}