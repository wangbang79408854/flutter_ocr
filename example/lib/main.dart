import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:ocr_plugin/ocr_plugin.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Database database;

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  void initDb() async {
    // open the database
    database = await openDatabase('demo.db', version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });

// Update some record
    int count = await database.rawUpdate(
        'UPDATE Test SET name = ?, VALUE = ? WHERE name = ?',
        ['updated name', '9876', 'some name']);
    print('updated: $count');

    // Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    print(list);

// Count the records
    count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM Test'));
  }

  insertData() async {
    // Insert some records in a transaction
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });
  }

  deleteData() async {
    await database.transaction((txn) async {});
  }

  @override
  void initState() {
    super.initState();
    initOcrSdk();
    initDb();
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
    print("$result");

    var decode = json.decode(result);

    var ocrResult = OcrResult.fromJson(decode);

    if(ocrResult.returnCode == 0){
      setState(() {
        _platformVersion = ocrResult.returnMsg;
      });
    }else{
      setState(() {
        _platformVersion = ocrResult.errorMsg;
      });
    }


  }

  bool cheched = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {},
            )
          ],
          centerTitle: true,
          title: Container(
            constraints: BoxConstraints.tight(Size.fromWidth(120)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "你们好123",
                  style: TextStyle(fontSize: 12.0),
                ),
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  value: cheched,
                  onChanged: (ischecked) {
                    setState(() {
                      cheched = ischecked;
                    });
                  },
                )
              ],
            ),
          ),
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

class OcrResult {
  int returnCode;
  String returnMsg;
  int errorCode;
  String errorMsg;

  OcrResult({this.returnCode, this.returnMsg, this.errorCode, this.errorMsg});

  OcrResult.fromJson(Map<String, dynamic> json) {
    returnCode = json['returnCode'];
    returnMsg = json['returnMsg'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['returnCode'] = this.returnCode;
    data['returnMsg'] = this.returnMsg;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}
