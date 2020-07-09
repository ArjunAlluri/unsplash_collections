import 'dart:ui';
import 'pets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  static List data = [];

  int page = 1;

  static List<String> urls = [];
  static int _count = 10;
  static List<String> description = [];
  static bool showing = false;

  void JsonData() async {
    http.Response response = await http.get(
        'https://api.unsplash.com//collections/1580860/photos?&page=${page}&client_id=pi9DbWg58gZNy-i-uX3kPSg3ddlutSkG35lSqee_m7g');

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
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text('Collections'),
                  centerTitle: true,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Text(
                        'Flowers',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Pets',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                body: TabBarView(children: <Widget>[Second(), Third()]))));
  }
}

class Second extends StatelessWidget {
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: GridView.builder(
            itemCount: MyAppState.data.length,
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
                          image: NetworkImage(MyAppState.urls.elementAt(index)),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      MyAppState.description[index] == null
                          ? 'Flowers'
                          : '${MyAppState.description[index]}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]));
            },
          ),
        ));
  }
}
