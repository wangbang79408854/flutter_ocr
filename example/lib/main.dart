import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ocr_plugin/ocr_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initOcrSdk();
  }

  Future<void> initOcrSdk() async {
    print("initOcrSDK");
    String result = await OcrPlugin.initOcrSdk(
        "FrvgGdKLgGMpvGfzfuabYwWl", "w3m3vFLXfAXkRcV8T2YQCQE0ExiyliGq");
    print("flutter_ocr_token=$result");


    setState(() {
      _platformVersion = result;
    });
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    
    var filepath = image.absolute.path;
    
    print("filepath = $filepath");
    var languageType = "CHN_ENG";

    String result = await OcrPlugin.recognize(filepath, languageType);
    setState(() {
      _platformVersion = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
