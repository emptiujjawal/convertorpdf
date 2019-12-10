import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_table/json_table.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:convertorpdf/conversion.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class Uploadf extends StatefulWidget {
  String cc;

  @override
  _UploadfState createState() => _UploadfState();
}

class _UploadfState extends State<Uploadf> {

  String _filePath;
  String sf='[{"id":1},{"id":2}]';
  bool toggle = true;
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }


  void readFileAsync() {
    File file = new File(_filePath); // (1)
    Future<String> futureContent = file.readAsString();

    futureContent.then((c) {
      sf= c;
      print(c);
    }); // (3)
  }

  void showSnackBar(BuildContext context){
    var snackBar= SnackBar(
        content: Text(" ")
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }
      print("File path: " + filePath);
      setState((){this._filePath = filePath;});
      readFileAsync();
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('File Picker'),

      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: toggle
        ?
    Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Add File first before clicking Proceed to convert", style: new TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.w200,
            fontStyle: FontStyle.italic
          ),
          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0)),
          new Container(
            child: new Center(
              child: _filePath == null
                  ? new Text('No file selected.')
                  : new Text('Path' + _filePath),
            ),

          ),
          new Padding(padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0)),
          new RaisedButton(
              splashColor: Colors.pinkAccent,
              color: Colors.black,
              child: new Text("Proceed to Convert into Data Table",style: new TextStyle(fontSize: 20.0,color: Colors.white),),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SimpleTable( value: sf )),
                );
              },
              ),

          //your elements here
        ],
      )
            : Center(
          child: Text(getPrettyJSONString(sf)),
        ),

      ),
      floatingActionButton: buildSpeedDial(),

    );
  }

  SpeedDial buildSpeedDial(){
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      //child: Icon(Icons.add),

      //visible: true,
      visible: dialVisible,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING'),
      onClose: () => print('CLOSED'),
      tooltip: 'Actions',
      heroTag: 'Features',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.sd_storage),
            backgroundColor: Colors.red,
            label: 'Select File',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => getFilePath()
        ),
        SpeedDialChild(
          child: Icon(Icons.grid_on),
          backgroundColor: Colors.blue,
          label: 'Toggle Data',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => setState((){toggle = !toggle;} ),
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_voice),
          backgroundColor: Colors.green,
          label: 'Third',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
        ),
      ],
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
  }






