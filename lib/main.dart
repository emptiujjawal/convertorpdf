import 'dart:convert';
import 'package:convertorpdf/Uploadfile.dart';
import 'package:convertorpdf/conversion.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


void main(){
  runApp(new MyApp());
}

final routes = {
  '/login': (BuildContext context  )=> new Uploadf(),
  //'/home': (BuildContext context) => SimpleTable(),
  '/': (BuildContext context) => new Uploadf()
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Coversion Json",
      theme: new ThemeData(primarySwatch: Colors.purple),
      routes: routes,
    );

  }
}

