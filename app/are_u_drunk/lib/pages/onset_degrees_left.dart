import 'package:are_u_drunk/pages/info_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'onset_degrees_right.dart';

class CheckOnsetDegreesLeftPage extends InfoPage {

  final String title = "Onset 45 degrees left";
  final String description = "Press to start checking the onset 45 degrees left. Look 45 degrees to your left.";
  final String image = "assets/onsetleft.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckOnsetDegreesLeftVideo(camera: camera);
  }
}

class CheckOnsetDegreesLeftVideo extends TakePictureScreen {
  final CameraDescription camera;

  const CheckOnsetDegreesLeftVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckOnsetDegreesLeftScreenState createState() => TakeVideoCheckOnsetDegreesLeftScreenState();
}

class TakeVideoCheckOnsetDegreesLeftScreenState extends TakeVideoScreenState {
  @override
  Widget getNextPage(String image) {
    return DisplayVideoOnsetDegreesLeft(image: image);
  }

}

class DisplayVideoOnsetDegreesLeft extends VideoPlayerScreen {

  final String image;

  const DisplayVideoOnsetDegreesLeft({Key? key, required this.image}) : super(path: image, endpoint: "onsetleft");

  @override
  Widget getNextPage() {
    return CheckOnsetDegreesRightPage();
  }

}