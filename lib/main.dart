import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String title = 'Flutter Demo Home Page';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(
        title: title,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _upperTabController;
  late TabController _lowerTabController;
  final List<String> _localIpList = ["http://localhost"];
  static double _iconSize = 100;
  final List<Icon> _usageIconList = [
    Icon(Icons.text_fields, size: _iconSize),
    Icon(Icons.wifi, size: _iconSize),
    Icon(Icons.connected_tv, size: _iconSize),
  ];
  @override
  void initState() {
    super.initState();
    _upperTabController = TabController(
      length: _localIpList.length,
      vsync: this,
      initialIndex: 0,
    );
    _lowerTabController = TabController(
      length: _usageIconList.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: GestureDetector(
            onVerticalDragEnd: (details) async {
              var httpClient = HttpClient();
              var request = await httpClient.get(
                  _localIpList[_upperTabController.index], 80, "/");

              if (details.primaryVelocity! > 0) {
                request.headers.add("Connection", "close");
                var response = await request.close();
                response.transform(utf8.decoder).listen((contents) {
                  print(contents);
                });
              } else if (details.primaryVelocity! < 0) {
                request.headers.add("Connection", "open");

                var response = await request.close();
                response.transform(utf8.decoder).listen((contents) {
                  print(contents);
                });
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                      controller: _upperTabController,
                      children: _localIpList.map((e) {
                        return Container(
                          child: Center(child: Text(e)),
                        );
                      }).toList()),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _lowerTabController,
                  children: _usageIconList.map((e) {
                    return Container(
                      color: Colors.blue,
                      child: e,
                    );
                  }).toList(),
                ))
              ],
            )));
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
