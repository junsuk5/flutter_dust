import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dust/air_info.dart';
import 'package:flutter_dust/models/AirResult.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AirInfo()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  void initState() {
    super.initState();

    // initState에서는 listen: false 꼭 해 줄 것
    Provider.of<AirInfo>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    AirInfo airInfo = Provider.of<AirInfo>(context);
    AirResult result = airInfo.result;

    return Scaffold(
      body: Center(
        child: airInfo.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '현재 위치 미세먼지',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('얼굴사진'),
                                  Text(
                                    '${result.data.current.pollution.aqius}',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  Text(
                                    getString(result),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              color: getColor(result),
                              padding: const EdgeInsets.all(8.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Image.network(
                                        'https://airvisual.com/images/${result.data.current.weather.ic}.png',
                                        width: 32,
                                        height: 32,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        '${result.data.current.weather.tp}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      '습도 ${result.data.current.weather.hu}%'),
                                  Text(
                                      '풍속 ${result.data.current.weather.ws}m/s'),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: RaisedButton(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50),
                          color: Colors.orange,
                          child: Icon(Icons.refresh, color: Colors.white),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius <= 100) {
      return '보통';
    } else if (result.data.current.pollution.aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
