
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterLbs {
  static const MethodChannel _channel =
      const MethodChannel('flutter_lbs');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get getLbsInfo async {
    final String lbsInfo = await _channel.invokeMethod('getLbsInfo');
    return lbsInfo;
  }
}
