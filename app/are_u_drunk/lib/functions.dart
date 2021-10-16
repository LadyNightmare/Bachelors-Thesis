
import 'dart:convert';
import 'package:are_u_drunk/server_uri.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

Future<String> callBackend(String endpoint, XFile file) async{

  String userIdentifier;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int fatherId = prefs.getInt('fatherId') ?? 0;
  try {
    userIdentifier = (await UniqueIdentifier.serial)!;
  } on PlatformException {
    userIdentifier = 'Failed to get Unique Identifier';
  }

  Uri url = Uri.https(uri, path + endpoint);

  http.MultipartRequest request =
  new http.MultipartRequest("POST", url);

  http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'media', await file.readAsBytes(),
      filename: file.path);
  request.fields['user'] = userIdentifier;
  request.fields['father_test_id'] = fatherId.toString();


  request.files.add(multipartFile);

  http.StreamedResponse response = await request.send();
  final body = await response.stream.bytesToString();
  final responseJson = jsonDecode(body);

  return responseJson['result'];
}

Future<int> initialize() async{

  String identifier;
  try {
    identifier = (await UniqueIdentifier.serial)!;
  } on PlatformException {
    identifier = 'Failed to get Unique Identifier';
  }

  Uri url = Uri.https(uri, path + "initialize");

  http.MultipartRequest request =
  new http.MultipartRequest("POST", url);
  request.fields['user'] = identifier;

  http.StreamedResponse response = await request.send();
  final body = await response.stream.bytesToString();
  final responseJson = jsonDecode(body);

  return responseJson['father_id'];
}