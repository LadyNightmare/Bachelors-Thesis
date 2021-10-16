import 'package:are_u_drunk/functions.dart';
import 'package:are_u_drunk/pages/smooth_right_eye.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'info_page.dart';

class CheckSmoothPursuitLeftPage extends InfoPage {

  final String title = "Smooth pursuit left";
  final String description = "Press to start checking the smooth pursuit left. Look slowly and smoothly to your left.";
  final String image = "assets/smoothleft.gif";

  @override
  Widget getNextPage(CameraDescription camera) {
    return CheckSmoothPursuitLeftVideo(camera: camera);
  }

}

class CheckSmoothPursuitLeftVideo extends TakePictureScreen {
  final CameraDescription camera;

  const CheckSmoothPursuitLeftVideo({Key? key, required this.camera}) : super(camera: camera);

  @override
  TakeVideoCheckSmoothPursuitLeft createState() => TakeVideoCheckSmoothPursuitLeft();
}

class TakeVideoCheckSmoothPursuitLeft extends TakeVideoScreenState {

  @override
  dynamic getNextPage(String path) {
    return DisplayVideoSmoothPursuitLeft(image: path);
  }

}

class DisplayVideoSmoothPursuitLeft extends VideoPlayerScreen {

  final String image;

  const DisplayVideoSmoothPursuitLeft({Key? key, required this.image}) : super(path: image, endpoint: "smoothleft");


  @override
  Widget getNextPage() {
    return CheckSmoothPursuitRightPage();
  }

}