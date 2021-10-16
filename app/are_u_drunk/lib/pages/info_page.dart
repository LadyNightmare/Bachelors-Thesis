import 'dart:io';

import 'package:are_u_drunk/functions.dart';
import 'package:are_u_drunk/pages/result_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../main.dart';

int failedClues = 0;

abstract class InfoPage extends StatelessWidget {
  abstract final String title;
  abstract final String description;
  abstract final String image;
  late final fatherTest;
  final IconData button = Icons.camera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Are-U-Drunk?"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                this.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child:  Text(
                this.description,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),)
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset(image),
            SizedBox(
              height: 50,
            ),
            Center(
              child: FloatingActionButton(
                child: getButton(),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            getNextPage(cameras[cameras.length - 1])),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget getButton() {
    return Icon(button);
  }

  Widget getNextPage(CameraDescription camera);
}

abstract class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);
}

abstract class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Are-U-Drunk?"),
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 50,
            ),
            FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Icon(Icons.cancel),
            ),
            SizedBox(
              width: 200,
            ),
            FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.

                print(imagePath);

                // If the picture was taken, display it on a new screen.

                Navigator.of(context).popUntil((route) => route.isFirst);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => getNextPage()));
              },
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }

  Widget getNextPage();
}

abstract class TakeVideoScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Icon fab = Icon(
    Icons.video_call,
  );

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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Are-U-Drunk?"),
        ),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 180,
                  ),
                  FloatingActionButton(
                      // Provide an onPressed callback.
                      onPressed: () async {
                        // Take the Picture in a try / catch block. If anything goes wrong,
                        // catch the error.

                        setState(() {
                          fab = Icon(Icons.videocam);
                        });

                        try {
                          // Ensure that the camera is initialized.
                          await _initializeControllerFuture;

                          // Attempt to take a picture and get the file `image`
                          // where it was saved.

                          await _controller.startVideoRecording();

                          await Future.delayed(
                              const Duration(seconds: 4), () {});

                          final image = await _controller.stopVideoRecording();

                          // If the picture was taken, display it on a new screen.
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => getNextPage(image.path)),
                          );

                          setState(() {
                            fab = Icon(Icons.video_call);
                          });
                        } catch (e) {
                          // If an error occurs, log the error to the console.
                          print(e);
                        }
                      },
                      child: fab),
                ])));
  }

  dynamic getNextPage(String path);
}

abstract class VideoPlayerScreen extends StatefulWidget {
  final String path;
  final String endpoint;

  const VideoPlayerScreen(
      {Key? key, required this.path, required this.endpoint})
      : super(key: key);

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();

  Widget getNextPage();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController playerController;

  late BuildContext context;

  @override
  void initState() {
    super.initState();

    File video = File(widget.path);

    print(video);

    playerController = VideoPlayerController.file(video);
    playerController.addListener(() {
      setState(() {});
    });

    playerController.initialize();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LoaderOverlay(child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Are-U-Drunk?"),
        ),
        body: Stack(fit: StackFit.loose, children: <Widget>[
          new AspectRatio(
            aspectRatio: playerController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(playerController),
                ClosedCaption(text: playerController.value.caption.text),
                _ControlsOverlay(controller: playerController),
                VideoProgressIndicator(playerController, allowScrubbing: true),
              ],
            ),
          ),
        ]),
        floatingActionButton: Container(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 50,
              ),
              FloatingActionButton(
                // Provide an onPressed callback.
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.cancel),
              ),
              SizedBox(
                width: 150,
              ),
              FloatingActionButton(
                // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.

                    context.loaderOverlay.show();

                    XFile video = XFile(widget.path);

                    String result = await callBackend(widget.endpoint, video);

                    context.loaderOverlay.hide();

                    if (result == "fail") {
                      failedClues += 1;
                    }

                    try {
                      if (result == "undetected") {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EyeDetectionFailPage()),
                        );
                      } else {
                        if (failedClues < 2) {
                          // If the picture was taken, display it on a new screen.
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => widget.getNextPage()),
                          );
                        } else {
                          failedClues = 0;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => DrunkPage()),
                          );
                        }
                      }
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  child: Icon(Icons.check)),
            ],
          ),
        )));
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
