import 'package:are_u_drunk/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: StartPage(),
    ),
  );
}

