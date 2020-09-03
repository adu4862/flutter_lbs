import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lbs/flutter_lbs.dart';
import 'package:flutter_lbs_example/StationInfo.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _lbsinfo = 'Unknown';
  String _lbslocationinfo = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<bool> canGetLbs() async {
    var status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (status != PermissionStatus.granted) {
      var future = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);
      for (final item in future.entries) {
        if (item.value != PermissionStatus.granted) {
          return false;
        }
      }
    } else {
      return true;
    }
    return true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterLbs.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: () {
                  clickGetLbs();
                },
                child: Text('获取lbs参数'),
              ),
              Text('lbs参数: $_lbsinfo\n'),
              RaisedButton(
                onPressed: () {
                  clickGetLbsLocation();
                },
                child: Text('获取lbs定位信息'),
              ),
              Text('lbs定位信息: $_lbslocationinfo\n'),
            ],
          ),
        ),
      ),
    );
  }

  void clickGetLbs() async {
    bool can = await canGetLbs();
    if (can) {
      String lbsinfo = await FlutterLbs.getLbsInfo;
      print(lbsinfo);
      setState(() {
        _lbsinfo =lbsinfo;
      });

    } else {
      print('位置权限获取失败');
    }
  }
  void clickGetLbsLocation() async {
    bool can = await canGetLbs();
    if (can) {
      String lbsinfo = await FlutterLbs.getLbsInfo;
      StationInfo info = stationInfoFromJson(lbsinfo);
      String url = "http://api.cellocation.com:81/cell/?mcc=${info.mcc}&mnc=${info.mnc}&lac=${info.lac}&ci=${info.cid}&output=json";
      print(url);
      getHttp(url);

    } else {
      print('位置权限获取失败');
    }
  }
  void getHttp(String url) async {
    try {
      Response response = await Dio().get(url);
      print(response);

      setState(() {
        _lbslocationinfo =response.toString();
      });
    } catch (e) {
      print(e);
    }
  }
}
