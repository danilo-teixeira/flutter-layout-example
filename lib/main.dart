import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'consts.dart';
import 'page_details/details.dart';

void main() {
  MapView.setApiKey(MAPS_API_KEY);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new DetailsPage(),
    );
  }
}