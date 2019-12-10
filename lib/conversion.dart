import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:json_table/json_table.dart';
import 'Uploadfile.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:ioc/ioc.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';





class SimpleTable extends StatefulWidget {
  final String value;

  SimpleTable({Key key, @required this.value}) : super(key: key);

  @override
  _SimpleTableState createState() => _SimpleTableState(value);
}

class _SimpleTableState extends State<SimpleTable> {
  final String jsonSample =
      '[{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India","area":"abc"},{"name":"Shyam","email":"shyam23@gmail.com",'
      '"age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India",'
      '"area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India","area":"abc","day":"Monday","month":"april"},'
      '{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com",'
      '"age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,"income":"10Rs","country":"India",'
      '"area":"abc","day":"Monday","month":"april"},{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc","day":"Monday","month":"april"},'
      '{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Ram","email":"ram@gmail.com","age":23,'
      '"income":"10Rs","country":"India","area":"abc","day":"Monday","month":"april"},{"name":"Shyam","email":"shyam23@gmail.com","age":28,"income":"30Rs","country":"India","area":"abc",'
      '"day":"Monday","month":"april"},{"name":"John","email":"john@gmail.com","age":33,"income":"15Rs","country":"India","area":"abc","day":"Monday","month":"april"}]';
   String value;
   _SimpleTableState(this.value);
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

  void setDialVisible(bool va) {
    setState(() {
      dialVisible = va;
    });
  }


  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(value);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Scaffold(
       resizeToAvoidBottomPadding: false,
       resizeToAvoidBottomInset: false,
      body:SingleChildScrollView(
          child: new Container(
        padding: EdgeInsets.all(16.0),
        child: toggle
            ? Column(
          children: [

            SizedBox(
              height: 40.0,
            ),
            Text("HONESTY IS THE BEST POLICY", textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.black),),
            JsonTable(
              json,
              showColumnToggle: false,

              tableHeaderBuilder: (String header) {
                return Container(
                 // constraints: BoxConstraints( maxWidth: 300.0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      color: Colors.white),
                  child: Text(
                    header,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: Colors.black87),
                  ),

                );
              },
              tableCellBuilder: (value) {
                return Container(
                 // constraints: BoxConstraints(maxWidth: 300.0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide( width: 0.5, color: Colors.grey.withOpacity(0.5)),
                          bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.5))
                          )
                  ),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                        fontSize: 14.0, color: Colors.grey[900]),
                  ),
                );
              },
            ),
            SizedBox(
              height: 40.0,
            ),
           // Text("Simple table which creates table direclty from json")
          ],
        )
            : Center(
          child: Text(getPrettyJSONString(value)),
        ),
      )),
       floatingActionButton: buildSpeedDial(),
    ),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }

  SpeedDial buildSpeedDial() {
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
            child: Icon(Icons.image),
            backgroundColor: Colors.red,
            label: 'IMG',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => ""
        ),
        SpeedDialChild(
          child: Icon(Icons.grid_on),
          backgroundColor: Colors.blue,
          label: 'Toggle Data',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () =>
              setState(() {
                toggle = !toggle;
              }),
        ),
        SpeedDialChild(
          child: Icon(Icons.picture_as_pdf),
          backgroundColor: Colors.green,
          label: 'PDF',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('THIRD CHILD'),
        ),
      ],
    );
  }


/*
  _generatePdfAndView(context) async {
    //List<BaseballModel> data = await jsonSample;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
        pdfLib.MultiPage(
            build: (context) => [
            pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
        <String>['Name', 'Coach', 'players'],
            ...data.map(
            (item) => [item.name, item.coach, item.players.toString()])
    ]),
    ],
    ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/baseball_teams.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (_) => PdfViewerPage(path: path),
    ),
    );
  }
  */
}
