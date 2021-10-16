import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Align(
              alignment: Alignment.center,
              // Align however you like (i.e .centerRight, centerLeft)
              child: Text("Are-U-Drunk?"),
            ),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                "How the test works",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "A screen with some information about the clue is displayed. Later, "
                      "a camera preview is shown to record 4 seconds of video. The video "
                      "stops recording automatically. A video preview is shown to accept or "
                      "reject it to record it again until the user considers it is good enough.",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ));
  }
}