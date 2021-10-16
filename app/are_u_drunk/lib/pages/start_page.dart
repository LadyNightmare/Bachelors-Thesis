import 'package:are_u_drunk/pages/onset_degrees_left.dart';
import 'package:are_u_drunk/pages/smooth_left_eye.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions.dart';
import 'help_page.dart';


class StartPage extends StatelessWidget {
  final String title = "Press the button to start the test.";
  final IconData button = Icons.check;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
            title:Text("Are-U-Drunk?"),
            automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text("Help"), value: "/help"),
              ],
              onSelected: (route) {
                // Note You must create respective pages for navigation
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => HelpPage()));
              },
            ),
          ],
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
            SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Image.asset('assets/eye_icon.jpg'),
            ),
            SizedBox(height: 50,),
            Center(
              child: FloatingActionButton(
                  child: Text("START"),
                  onPressed: () async {
                    await initializeTest();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckSmoothPursuitLeftPage()),
                    );
                  },
                ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: RichText(
                text: new TextSpan(
                  children:[
                   new TextSpan(
                     text:"By using this application you accept the ",
                     style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                     //textAlign: TextAlign.center,
                   ),
                    TextSpan(
                      text: "Terms and Conditions.",
                      style: new TextStyle(color: Colors.blue, fontSize: 10,fontWeight: FontWeight.bold),
                      recognizer: new TapGestureRecognizer()
                      ..onTap = () async {
                        final url = 'https://drive.google.com/file/d/1RqG7yTPxhJPPcq_3cza_SJMRTJNwX-Na/view?usp=sharing';
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                          );
                        }
                      },
                    )
                  ]
                )
              ),
            ),
          ],
        ));
  }

  Future<void> initializeTest() async {
    int fatherId = await initialize();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fatherId', fatherId);
  }


}