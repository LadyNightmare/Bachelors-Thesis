import 'package:are_u_drunk/pages/start_page.dart';
import 'package:flutter/material.dart';

abstract class ResultPage extends StatelessWidget {
  abstract final String result;
  abstract final String advice;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Align(
          alignment: Alignment.center,
          // Align however you like (i.e .centerRight, centerLeft)
          child: Text("Are-U-Drunk?"),
        ),
            automaticallyImplyLeading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                this.result,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  this.advice,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 70,),
            Center(
              child: FloatingActionButton(
                child: Text("OK"),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StartPage()),
                  );
                },
              ),
            ),
          ],
        ));
  }
}


class DrunkPage extends ResultPage {
  final String result =
      "You are drunk!";
  final String advice = "Please do not drive under the effects of alcohol.";
}

class SoberPage extends ResultPage {
  final String result = "You are sober.";
  final String advice = "You can drive. Have a safe trip.";
}

class EyeDetectionFailPage extends ResultPage {

  final String result = "Your eyes could not be detected.";
  final String advice = "Retake the test or consider contacting health services.";

}