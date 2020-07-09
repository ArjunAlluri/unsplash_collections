import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class Third extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ThirdState();
  }
}

class ThirdState extends State<Third> {
  static List data = [];
  static List<String> urls = [];
  static List<String> description = [];
  static bool showing = false;
  void JsonData() async {
    http.Response response = await http.get(
        'https://api.unsplash.com//collections/139386/photos/?client_id=pi9DbWg58gZNy-i-uX3kPSg3ddlutSkG35lSqee_m7g');

    data = json.decode(response.body);
    getData();
    setState(() {
      showing = true;
    });
  }

  getData() {
    for (var i = 0; i < data.length; i++) {
      urls.add(data.elementAt(i)["urls"]["regular"]);
      description.add(data.elementAt(i)["alt_description"]);
    }
  }

  Widget build(BuildContext context) {
    JsonData();
    return MaterialApp(home: Scaffold(body: Pets()));
  }
}

class Pets extends StatelessWidget {
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: GridView.builder(
            itemCount: ThirdState.data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: widthScreen / heightScreen),
            itemBuilder: (context, index) {
              return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(children: <Widget>[
                    Container(
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(ThirdState.urls.elementAt(index)),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      ThirdState.description[index] == null
                          ? 'Cat'
                          : '${ThirdState.description[index]}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]));
            },
          ),
        ));
  }
}
